# frozen_string_literal: true

class PreferencesController < ApplicationController
  before_action :require_current_user

  def show
    @preference = UserPreference.new(current_user.preference)
  end

  def update
    @preference = UserPreference.new(current_user.preference.merge(preference_params))

    if @preference.valid?
      current_user.update!(preference: @preference.as_json)
      redirect_to preference_path, notice: '更新しました'
    else
      render :show
    end
  end

  private

  def preference_params
    params.require(:user_preference).permit(:works_order)
  end
end
