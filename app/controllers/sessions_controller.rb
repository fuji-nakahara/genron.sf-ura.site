# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create if Rails.env.development?

  def create
    auth_hash = request.env['omniauth.auth']
    user = User.find_or_initialize_by(twitter_id: auth_hash.uid)

    if user.new_record?
      TwitterFollowJob.perform_later(user.twitter_id)

      student = StudentTwitterCandidate.find_by(twitter_screen_name: auth_hash.info.nickname)&.student
      student ||= Student.find_by(genron_sf_id: auth_hash.info.nickname.sub('_', '').downcase)
      if student
        Sentry.capture_message(
          '受講生がログインした可能性があります',
          level: :info,
          extra: {
            genron_sf_url: student.url,
            twitter_url: auth_hash.info.urls['Twitter'],
          },
        )
        user.student_merge_candidates.build(student:)
      end
    end

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
