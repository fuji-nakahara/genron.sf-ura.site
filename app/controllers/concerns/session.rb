# frozen_string_literal: true

module Session
  extend ActiveSupport::Concern

  included do
    helper_method :current_user
  end

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def require_current_user
    redirect_to root_path, alert: 'ログインしてください' if current_user.nil?
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def log_out
    @current_user = nil
    reset_session
  end
end
