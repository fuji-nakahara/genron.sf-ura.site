# frozen_string_literal: true

class StudentsController < ApplicationController
  def index
    @term = Term.find(params[:term_year])
    @students = Student.joins(works: :kadai)
                       .merge(Kadai.where(year: @term.year))
                       .with_votes_sum
                       .order(votes_sum: :desc, genron_sf_id: :asc)
  end

  def show
    @student = Student.where(id: params[:id]).or(Student.where(genron_sf_id: params[:id])).take!
    @jissakus = @student.jissakus.includes(:prize, :kadai, :voters).reverse_order
    @kougais = @student.kougais.includes(:kadai, :voters).reverse_order
  end
end
