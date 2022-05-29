# frozen_string_literal: true

class StudentsController < ApplicationController
  def index
    @term = Term.find(params[:term_year])
    @students = Student.joins(works: :kadai)
                       .merge(Kadai.where(year: @term.year))
                       .with_works_stats
                       .order(votes_sum: :desc, genron_sf_id: :asc)

    respond_to do |format|
      format.html do
        @years = Term.order(year: :desc).pluck(:year)
      end

      format.json do
        render json: @students.as_json(
          only: %i[id genron_sf_id name url description kougais_count jissakus_count votes_sum],
        )
      end
    end
  end

  def show
    @student = Student.where(id: params[:id]).or(Student.where(genron_sf_id: params[:id])).take!

    respond_to do |format|
      format.html do
        @stats = @student.works.stats_by_year.reverse_order
      end

      format.json do
        render json: @student.as_json
      end
    end
  end
end
