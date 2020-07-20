# frozen_string_literal: true

class ScoresController < ApplicationController
  def show
    year = params[:year]&.to_i
    return head :not_found unless Kadai::YEARS.include?(year)

    score_table = Rails.cache.fetch("score_chart/#{year}/score_table/", expires_in: 1.day) do
      GenronSF::ScoreTable.get(year: year).to_h
    end
    render json: score_table.map { |student, scores| { student: student, scores: scores } }
  end
end
