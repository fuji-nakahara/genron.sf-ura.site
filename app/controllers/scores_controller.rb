# frozen_string_literal: true

class ScoresController < ApplicationController
  def index
    term = Term.find(params[:term_year])
    score_table = Rails.cache.fetch("#{term.year}/score_table/", expires_in: 1.day) do
      GenronSF::ScoreTable.get(year: term.year).to_h
    end
    render json: score_table.map { |student, scores| { student: student, scores: scores } }
  end
end
