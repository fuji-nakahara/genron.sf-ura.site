# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LinksController:', type: :request do
  describe 'POST /kadais/:kadai_id/links' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai) }
    let(:params) do
      {
        link: {
          url: url,
        },
      }
    end
    let(:url) { 'https://example.com/link' }

    before do
      log_in user

      allow(OpenGraphReader).to receive(:fetch!).and_return(
        double(
          :object,
          og: instance_double(OpenGraphReader::Og, url: url, title: 'タイトル'),
        ),
      )
    end

    it 'creates a link and redirects to /kadais/:id' do
      expect { post kadai_links_path(kadai), params: params }
        .to change { kadai.links.count }.by(1)

      expect(response).to redirect_to kadai
    end

    context 'when failed to fetch OpenGraph data' do
      before do
        allow(OpenGraphReader).to receive(:fetch!).and_raise(OpenGraphReader::NoOpenGraphDataError)
      end

      it 'redirects to /kadais/:id' do
        expect { post kadai_links_path(kadai), params: params }
          .not_to(change { kadai.links.count })

        expect(response).to redirect_to kadai
      end
    end
  end

  describe 'DELETE /links/:id' do
    let(:user) { create(:user) }
    let(:link) { create(:link, user: user) }

    before do
      log_in user
    end

    it 'destroys the link' do
      delete link_path(link)

      expect { link.reload }.to raise_error ActiveRecord::RecordNotFound
      expect(response).to have_http_status :redirect
    end
  end
end
