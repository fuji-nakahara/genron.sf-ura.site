# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LinksController:' do
  describe 'POST /:term_year/:kadai_round/links' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai) }
    let(:params) do
      {
        link: {
          url:,
        },
      }
    end
    let(:url) { 'https://example.com/link' }

    before do
      log_in user

      allow(OpenGraphReader).to receive(:fetch!).and_return(
        double(
          :object,
          og: instance_double(OpenGraphReader::Og, url:, title: 'タイトル'),
        ),
      )
    end

    it 'creates a link and redirects to /:term_year/:round' do
      expect { post term_kadai_links_path(kadai.year, kadai), params: }
        .to change { kadai.links.count }.by(1)

      expect(response).to redirect_to term_kadai_path(kadai.year, kadai)
    end

    context 'when failed to fetch OpenGraph data' do
      before do
        allow(OpenGraphReader).to receive(:fetch!).and_raise(OpenGraphReader::NoOpenGraphDataError)
      end

      it 'redirects to /:term_year/:round' do
        expect { post term_kadai_links_path(kadai.year, kadai), params: }
          .not_to(change { kadai.links.count })

        expect(response).to redirect_to term_kadai_path(kadai.year, kadai)
      end
    end
  end

  describe 'DELETE /links/:id' do
    let(:user) { create(:user) }
    let(:link) { create(:link, user:) }

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
