# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'KougaisController:', type: :request do
  describe 'GET /:term_year/:kadai_round/kougais/new' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai, kougai_deadline: 1.day.from_now.to_date) }

    before do
      log_in user
    end

    it 'responds OK' do
      get new_term_kadai_kougai_path(*kadai.year_round)

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /:term_year/:kadai_round/kougais' do
    let(:user) { create(:user) }
    let(:kadai) { create(:kadai, kougai_deadline: 1.day.from_now.to_date) }
    let(:params) do
      {
        kougai: {
          title: '式年遷皇',
          url: url,
        },
      }
    end
    let(:url) { 'https://kakuyomu.jp/my/works/1177354054885765919/episodes/1177354054888143256' }

    before do
      log_in user
    end

    it 'creates a kougai and redirects to /:term_year/:round' do
      expect { post term_kadai_kougais_path(*kadai.year_round), params: params }
        .to change { kadai.kougais.count }.by(1)

      expect(response).to redirect_to term_kadai_path(*kadai.year_round)
    end

    context 'when url is invalid' do
      let(:url) { 'ftp://example.com/invalid' }

      it 'renders error' do
        expect { post term_kadai_kougais_path(*kadai.year_round), params: params }
          .not_to(change { kadai.kougais.count })

        expect(response).to have_http_status :ok
      end
    end
  end
end
