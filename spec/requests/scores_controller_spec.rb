# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ScoresController:' do
  describe 'GET /:term_year/scores' do
    let(:term) { create(:term) }

    it 'returns scores for the requested term' do
      allow(GenronSF::ScoreTable).to receive(:get).and_return({ 'フジ・ナカハラ' => [1, 2] })

      get term_scores_path(term, format: :json)

      expect(GenronSF::ScoreTable).to have_received(:get).with(year: term.year)
      expect(response).to have_http_status :ok
      expect(response.parsed_body).to eq([{ 'student' => 'フジ・ナカハラ', 'scores' => [1, 2] }])
    end

    it 'returns a JSON error when the upstream score table redirects' do
      stub_request(:get, term.genron_sf_scores_url).to_return(
        status: 301,
        headers: { 'Location' => 'https://school.genron.co.jp/works/sf/top-2016/scores/' },
      )

      get term_scores_path(term, format: :json)

      expect(response).to have_http_status :bad_gateway
      expect(response.parsed_body).to eq({ 'error' => 'score_table_unavailable' })
    end
  end
end
