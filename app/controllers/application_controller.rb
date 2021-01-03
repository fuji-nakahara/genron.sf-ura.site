# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Session

  before_action :set_sentry_user

  private

  def set_sentry_user
    Sentry.set_user(
      {
        id: current_user&.id,
        username: current_user&.twitter_screen_name,
        ip_address: request.ip,
      }.compact,
    )
  end
end
