# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Session

  before_action :set_raven_context

  private

  def set_raven_context
    Raven.user_context(
      {
        id: current_user&.id,
        username: current_user&.twitter_screen_name,
        ip_address: request.ip,
      }.compact,
    )
  end
end
