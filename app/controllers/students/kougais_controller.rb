# frozen_string_literal: true

module Students
  class KougaisController < ApplicationController
    def index
      student = Student.find_by(genron_sf_id: params[:student_id]) || Student.find(params[:student_id])
      render json: student.kougais.includes(:kadai, :voters).as_json(include: %i[kadai student voters])
    end
  end
end
