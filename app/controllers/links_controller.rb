# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :require_current_user

  def create
    kadai = Kadai.find(params[:kadai_id])
    link = kadai.links.build(user: current_user, url: params[:link][:url])

    if link.save
      flash.notice = '登録しました'
    else
      flash.alert = link.errors.full_messages.join(' / ')
    end
    redirect_to term_kadai_path(*kadai.year_round)
  end

  def destroy
    link = Link.find(params[:id])
    link.destroy!
    redirect_back fallback_location: link.kadai
  end
end
