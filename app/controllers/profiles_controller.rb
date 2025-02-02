# frozen_string_literal: true

class ProfilesController < ApplicationController
  before_action :require_current_user

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

  def profile_params
    if current_user.student.genron_sf_id
      params.expect(student: [:description])
    else
      params.expect(student: %i[name url description])
    end
  end
end
