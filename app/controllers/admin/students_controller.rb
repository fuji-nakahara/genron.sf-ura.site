# frozen_string_literal: true

module Admin
  class StudentsController < ApplicationController
    include AdminRequired

    def merge
      return head :bad_request if params[:genron_sf_id].blank? || params[:twitter_screen_name].blank?

      MergeStudentsJob.perform_now(
        genron_sf_id: params[:genron_sf_id],
        twitter_screen_name: params[:twitter_screen_name],
      )

      redirect_to admin_root_path, notice: 'マージしました'
    end
  end
end
