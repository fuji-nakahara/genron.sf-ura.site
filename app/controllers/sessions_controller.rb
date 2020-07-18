# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_or_initialize_by(twitter_id: auth_hash.uid)
    TwitterFollowJob.perform_later(user.twitter_id) if user.new_record?
    user.save_auth_hash!(auth_hash)
    log_in user
    redirect_to request.env['omniauth.origin'] || root_path, notice: 'ログインしました'
  end

  def failure
    flash.alert = "ログインに失敗しました: #{params[:message]}" if params[:message].present?
    redirect_to root_path
  end

  def destroy
    log_out
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
