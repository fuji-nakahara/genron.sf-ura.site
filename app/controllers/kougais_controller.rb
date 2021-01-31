# frozen_string_literal: true

class KougaisController < ApplicationController
  before_action :require_current_user

  def new
    kadai = Kadai.where('kougai_deadline >= ?', Time.zone.today)
                 .find_by!(year: params[:term_year], round: params[:kadai_round])
    @kougai = kadai.kougais.build(student: current_user.student)
  end

  def create
    kadai = Kadai.where('kougai_deadline >= ?', Time.zone.today)
                 .find_by!(year: params[:term_year], round: params[:kadai_round])
    @kougai = kadai.kougais.build(kougai_params.merge(student: current_user.student))

    if @kougai.save
      TweetWorkSubmittedJob.perform_later(@kougai)
      redirect_to term_kadai_path(kadai.year, kadai), notice: '登録しました'
    else
      render :new
    end
  end

  private

  def kougai_params
    params.require(:kougai).permit(:title, :url)
  end
end
