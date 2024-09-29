# frozen_string_literal: true

class RefreshOldTwitterTokensJob < ApplicationJob
  def perform
    Twitter2Credential.where.not(refresh_token: nil).where(updated_at: ...5.months.ago).find_each do |credential|
      credential.refresh!
    rescue TwitterClient::BadRequestError => e
      if e.body['error_description'] == 'Value passed for the token was invalid.'
        credential.update!(refresh_token: nil)
        logger.info "Invalid refresh token: user_id=#{credential.user_id}"
      else
        Sentry.capture_exception(e, extra: e.body.merge(user.as_json), hint: { background: false })
      end
    rescue TwitterClient::Error => e
      Sentry.capture_exception(e, extra: e.body.merge(user.as_json), hint: { background: false })
    end
  end
end
