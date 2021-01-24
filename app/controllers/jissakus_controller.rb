# frozen_string_literal: true

class JissakusController < ApplicationController
  before_action :require_current_user

  def new
    kadai = Kadai.where('jissaku_deadline >= ?', Time.zone.today).find(params[:kadai_id])
    @jissaku = kadai.jissakus.build(student: current_user.student)
  end

  def create
    kadai = Kadai.where('jissaku_deadline >= ?', Time.zone.today).find(params[:kadai_id])
    @jissaku = kadai.jissakus.build(jissaku_params.merge(student: current_user.student))

    if @jissaku.save
      TweetWorkSubmittedJob.perform_later(@jissaku)
      redirect_to kadai, notice: '登録しました'
    else
      render :new
    end
  end

  private

  def jissaku_params
    params.require(:jissaku).permit(:title, :url)
  end
end
