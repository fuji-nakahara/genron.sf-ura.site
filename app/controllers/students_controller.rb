# frozen_string_literal: true

class StudentsController < ApplicationController
  def show
    @student = Student.find(params[:id])
    @jissakus = @student.jissakus.includes(:prize, :kadai, :voters).reverse_order
    @kougais = @student.kougais.includes(:kadai, :voters).reverse_order
  end

  def find
    student = Student.find_by!(genron_sf_id: params[:genron_sf_id])
    redirect_to student, status: :moved_permanently
  end
end
