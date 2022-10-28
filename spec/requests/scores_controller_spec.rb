# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ScoresController:' do
  describe 'GET /:term_year/scores' do
    let(:term) { create(:term) }

    before do
      allow(GenronSF::ScoreTable).to receive(:get).and_return({ 'フジ・ナカハラ' => [1, 2] })
    end

    it 'responds OK' do
      get term_scores_path(term, format: :json)

      expect(GenronSF::ScoreTable).to have_received(:get).with(year: term.year)
      expect(response).to have_http_status :ok
    end
  end
end
