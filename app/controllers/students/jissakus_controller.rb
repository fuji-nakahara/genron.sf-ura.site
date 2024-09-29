# frozen_string_literal: true

module Students
  class JissakusController < ApplicationController
    def index
      student = Student.find_by(genron_sf_id: params[:student_id]) || Student.find(params[:student_id])
      render json: student.jissakus.includes(:prize, :kadai, :voters).as_json(include: %i[prize kadai student voters])
    end
  end
end
