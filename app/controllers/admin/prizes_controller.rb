# frozen_string_literal: true

module Admin
  class PrizesController < ApplicationController
    include AdminRequired

    def create
      jissaku = Jissaku.find_by!(genron_sf_id: params[:genron_sf_id])
      Prize.create!(prize_params.merge(jissaku: jissaku))
      redirect_to admin_root_path, notice: '賞を作成しました'
    rescue => e # rubocop:disable Style/RescueStandardError
      redirect_to admin_root_path, alert: e.to_s
    end

    private

    def prize_params
      params.require(:prize).permit(:title, :position)
    end
  end
end
