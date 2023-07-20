# frozen_string_literal: true

module Session
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  private

  def current_user
    @current_user ||= User.active.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_current_user
    return if current_user

    if request.xhr?
      render status: :unauthorized, json: { errors: %w[ログインしてください] }
    else
      redirect_back fallback_location: root_path, allow_other_host: false, alert: 'ログインしてください'
    end
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    @current_user = nil
    reset_session
  end
end
