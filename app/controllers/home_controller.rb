# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @kadais = Kadai.newest3
    @votes = Vote.includes(:user, work: :student).reverse_order.limit(6)
    score_table = Rails.cache.fetch("score_table/#{Kadai::LATEST_YEAR}", expires_in: 1.day) do
      GenronSF::ScoreTable.get(year: Kadai::LATEST_YEAR).to_h
    end
    @score_chart = ScoreChart.new(score_table)
  end
end
