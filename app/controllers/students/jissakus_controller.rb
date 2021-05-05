# frozen_string_literal: true

module Students
  class JissakusController < ApplicationController
    def index
      student = Student.where(id: params[:student_id]).or(Student.where(genron_sf_id: params[:student_id])).take!
      render json: student.jissakus.includes(:prize, :kadai, :voters).as_json(include: %i[prize kadai student voters])
    end
  end
end
