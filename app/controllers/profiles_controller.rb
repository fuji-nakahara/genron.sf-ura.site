# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :require_current_user
  before_action :require_ura_student

  def show
    @student = current_user.student
  end

  def update
    @student = current_user.student

    if @student.update(profile_params)
      redirect_to profile_path, notice: '更新しました'
    else
      render :show
    end
  end

  private

  def require_ura_student
    redirect_to current_user.student.url if current_user.student.genron_sf_id
  end

  def profile_params
    params.require(:student).permit(:name, :url)
  end
end
