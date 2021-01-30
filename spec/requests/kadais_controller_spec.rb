# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'KadaisController:', type: :request do
  describe 'GET /:term_year/:round' do
    let(:kadai) { create(:kadai) }

    before do
      create_pair(:jissaku, kadai: kadai)
      create_pair(:kougai, kadai: kadai)
    end

    it 'responds OK' do
      get term_kadai_path(*kadai.year_round)

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /kadais/:id' do
    let(:kadai) { create(:kadai) }

    it 'redirects to /:term_year/:round' do
      get kadai_path(kadai)

      expect(response).to redirect_to term_kadai_path(*kadai.year_round)
    end
  end
end
