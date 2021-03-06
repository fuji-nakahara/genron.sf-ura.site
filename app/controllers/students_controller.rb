# frozen_string_literal: true

class StudentsController < ApplicationController
  def index
    @term = Term.find(params[:term_year])
    @students = Student.joins(works: :kadai)
                       .merge(Kadai.where(year: @term.year))
                       .with_votes_sum
                       .order(votes_sum: :desc, genron_sf_id: :asc)

    respond_to do |format|
      format.html

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
        @votes_sum_by_year = @student.works.joins(:kadai).order('kadais.year': :desc)
                                     .group(:'kadais.year').sum(:votes_count)
        @jissakus_by_year = @student.jissakus.includes(:prize, :kadai, :voters).reverse_order
                                    .group_by { |jissaku| jissaku.kadai.year }
        @kougais_by_year = @student.kougais.includes(:kadai, :voters).reverse_order
                                   .group_by { |kougai| kougai.kadai.year }
      end

      format.json do
        render json: @student.as_json.merge(
          jissakus: @student.jissakus.includes(:kadai, :voters).order(:id).as_json(include: %i[kadai voters]),
          kougais: @student.kougais.includes(:kadai, :voters).order(:id).as_json(include: %i[kadai voters]),
        )
      end
    end
  end
end
