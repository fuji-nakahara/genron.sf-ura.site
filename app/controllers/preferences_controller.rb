# frozen_string_literal: true

class PreferencesController < ApplicationController
  def update
    @preference = UserPreference.new(current_user.preference.merge(preference_params))

    if @preference.valid?
      current_user.update!(preference: @preference.as_json)
      head :no_content
    else
      render status: :bad_request, json: { errors: @preference.errors.full_messages }
    end
  end

  private

  def preference_params
    params.permit(:works_order)
  end
end
