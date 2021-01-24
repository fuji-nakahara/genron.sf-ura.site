# frozen_string_literal: true

class StudentsController < ApplicationController
  def show
    @student = Student.find(params[:id])
    @jissakus = @student.jissakus.includes(:prize, :kadai, :voters).reverse_order
    @kougais = @student.kougais.includes(:kadai, :voters).reverse_order
  end
end
