# frozen_string_literal: true

module AdminRequired
  ADMIN_TWITTER_SCREEN_NAME = 'fuji_nakahara'

  extend ActiveSupport::Concern

  included do
    before_action :require_current_user
    before_action :require_admin
  end

  private

  def require_admin
    head :not_found if current_user.twitter_screen_name != ADMIN_TWITTER_SCREEN_NAME
  end
end
