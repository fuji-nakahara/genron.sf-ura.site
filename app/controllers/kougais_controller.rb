# frozen_string_literal: true

class KougaisController < ApplicationController
  before_action :require_current_user

  def new
    kadai = Kadai.find(params[:kadai_id])
    @kougai = kadai.kougais.build(student: current_user.student)
  end

  def create
    kadai = Kadai.find(params[:kadai_id])
    kougai = kadai.kougais.build(kougai_params.merge(student: current_user.student))

    if kougai.save
      redirect_to kadai, notice: '登録しました'
    else
      render :new
    end
  end

  private

  def kougai_params
    params.require(:kougai).permit(:title, :url)
  end
end
