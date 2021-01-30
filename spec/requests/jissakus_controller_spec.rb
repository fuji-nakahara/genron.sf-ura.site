# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'JissakusController:', type: :request do
  describe 'GET /:term_year/:kadai_round/jissakus/new' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai, jissaku_deadline: 1.day.from_now.to_date) }

    before do
      log_in user
    end

    it 'responds OK' do
      get new_term_kadai_jissaku_path(*kadai.year_round)

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /:term_year/:kadai_round/jissakus' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai, jissaku_deadline: 1.day.from_now.to_date) }
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

    it 'creates a jissaku and redirects to /:term_year/:round' do
      expect { post term_kadai_jissakus_path(*kadai.year_round), params: params }
        .to change { kadai.jissakus.count }.by(1)

      expect(response).to redirect_to term_kadai_path(*kadai.year_round)
    end

    context 'when url is invalid' do
      let(:url) { 'ftp://example.com/invalid' }

      it 'renders error' do
        expect { post term_kadai_jissakus_path(*kadai.year_round), params: params }
          .not_to(change { kadai.jissakus.count })

        expect(response).to have_http_status :ok
      end
    end
  end
end
