# frozen_string_literal: true

class StudentsController < ApplicationController
  def show
    @student = Student.where(id: params[:id]).or(Student.where(genron_sf_id: params[:id])).take!
    @jissakus = @student.jissakus.includes(:prize, :kadai, :voters).reverse_order
    @kougais = @student.kougais.includes(:kadai, :voters).reverse_order
  end
end
