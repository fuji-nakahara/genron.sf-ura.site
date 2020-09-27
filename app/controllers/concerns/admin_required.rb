# frozen_string_literal: true

module AdminRequired
  extend ActiveSupport::Concern

  included do
    before_action :require_current_user
    before_action :require_admin
  end

  private

  def require_admin
    redirect_back fallback_location: root_path, allow_other_host: false, alert: '権限がありません' unless current_user.admin?
  end
end
