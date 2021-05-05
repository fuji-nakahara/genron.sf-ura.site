# frozen_string_literal: true

module Students
  class KougaisController < ApplicationController
    def index
      student = Student.where(id: params[:student_id]).or(Student.where(genron_sf_id: params[:student_id])).take!
      render json: student.kougais.includes(:kadai, :voters).as_json(include: %i[kadai student voters])
    end
  end
end
