# frozen_string_literal: true

module Admin
  class ElectionsController < ApplicationController
    include AdminRequired

    def create
      kougai = Kougai.find_by!(genron_sf_id: params[:genron_sf_id])
      kougai.create_election!(election_params)
      redirect_to admin_root_path, notice: "#{kougai.student.name}『#{kougai.title}』の選出を設定しました"
    rescue => e # rubocop:disable Style/RescueStandardError
      redirect_to admin_root_path, alert: e.to_s
    end

    private

    def election_params
      params.require(:election).permit(:tweet_url)
    end
  end
end
