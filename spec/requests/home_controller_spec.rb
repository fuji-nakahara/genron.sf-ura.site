# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HomeController:', type: :request do
  describe 'GET /' do
    before do
      create(:kadai)
      allow(GenronSF::ScoreTable).to receive(:get).and_return(
        { 'フジ・ナカハラ' => [1, 2, 3, 4, 5, 6, 7, 8, 9] },
      )
    end

    it 'responds OK' do
      get root_path

      expect(response).to have_http_status :ok
    end
  end
end
