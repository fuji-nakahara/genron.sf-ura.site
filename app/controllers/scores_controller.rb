# frozen_string_literal: true

class ScoresController < ApplicationController
  def index
    @term = Term.find(params[:term_year])

    respond_to do |format|
      format.html

      format.json do
        score_table = Rails.cache.fetch("score_table/#{@term.year}") do
          GenronSF::ScoreTable.get(year: @term.year).to_h
        end

        render json: score_table.map { |student, scores| { student:, scores: } }
      end
    end
  end
end
