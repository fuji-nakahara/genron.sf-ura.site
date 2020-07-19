# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JissakusController:', type: :request do
  describe 'GET /kadais/:kadai_id/jissakus/new' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai) }

    before do
      log_in user
    end

    it 'responds OK' do
      get new_kadai_jissaku_path(kadai)

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /kadais/:kadai_id/jissakus' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai) }
    let(:params) do
      {
        jissaku: {
          title: '透明な血のつながり',
          url: url,
        },
      }
    end
    let(:url) { 'https://kakuyomu.jp/my/works/1177354054885765919/episodes/1177354054887464835' }

    before do
      log_in user
    end

    it 'creates a jissaku and redirects to /kadais/:id' do
      expect { post kadai_jissakus_path(kadai), params: params }
        .to change { kadai.jissakus.count }.by(1)

      expect(response).to redirect_to kadai
    end

    context 'when url is invalid' do
      let(:url) { 'ftp://example.com/invalid' }

      it 'renders error' do
        expect { post kadai_jissakus_path(kadai), params: params }
          .not_to(change { kadai.jissakus.count })

        expect(response).to have_http_status :ok
      end
    end
  end
end
