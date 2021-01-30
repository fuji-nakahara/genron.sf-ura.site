# frozen_string_literal: true

class ScoresController < ApplicationController
  def show
    term = Term.find(params[:year])

    score_table = Rails.cache.fetch("score_chart/#{term.year}/score_table/", expires_in: 1.day) do
      GenronSF::ScoreTable.get(year: term.year).to_h
    end
    render json: score_table.map { |student, scores| { student: student, scores: scores } }
  end
end
