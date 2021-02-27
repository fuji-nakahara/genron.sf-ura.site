# frozen_string_literal: true

module Admin
  class JobsController < ApplicationController
    include AdminRequired

    def create
      return head :bad_request if params[:job_class].blank?

      job_class = params[:job_class].camelize.constantize
      job_class.perform_later
      redirect_to admin_root_path, notice: "#{job_class} を実行しました"
    rescue => e # rubocop:disable Style/RescueStandardError
      redirect_to admin_root_path, alert: e.to_s
    end
  end
end
