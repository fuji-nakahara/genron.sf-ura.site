# frozen_string_literal: true

class StudentsController < ApplicationController
  def show
    @student = Student.find(params[:id])
  end

  def find
    @student = Student.find_by!(genron_sf_id: params[:genron_sf_id])
    redirect_to @student, status: :moved_permanently
  end
end
