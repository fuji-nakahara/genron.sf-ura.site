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
      TweetJob.perform_later(<<~TWEET)
        【実作】@#{current_user.twitter_screen_name}『#{@jissaku.title}』
        #裏SF創作講座
        #{kadai_url(kadai, anchor: "work-#{@jissaku.id}")}
        #{@jissaku.url}
      TWEET
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
