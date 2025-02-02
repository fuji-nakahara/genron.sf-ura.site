# frozen_string_literal: true

module Admin
  class PrizesController < ApplicationController
    include AdminRequired

    def create
      jissaku = Jissaku.find_by!(genron_sf_id: params[:genron_sf_id])
      jissaku.create_prize!(prize_params)
      redirect_to admin_root_path, notice: '賞を作成しました'
    rescue => e # rubocop:disable Style/RescueStandardError
      redirect_to admin_root_path, alert: e.to_s
    end

    private

    def prize_params
      params.expect(prize: %i[title position])
    end
  end
end
