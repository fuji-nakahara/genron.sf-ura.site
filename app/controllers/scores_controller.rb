# frozen_string_literal: true

class ScoresController < ApplicationController
  def index
    @term = Term.find(params[:term_year])

    score_table = Rails.cache.fetch("score_table/#{@term.year}", expires_in: 6.hours) do
      GenronSF::ScoreTable.get(year: @term.year).to_h
    end

    render json: score_table.map { |student, scores| { student:, scores: } }
  end
end
