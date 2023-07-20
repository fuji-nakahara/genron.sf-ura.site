# frozen_string_literal: true

class Twitter2Credential < ApplicationRecord
  class Error < StandardError; end

  belongs_to :user

  def fetch_valid_token!
    if expired?
      raise Error, 'No refresh token' if refresh_token.blank?

      refresh!
    end

    token
  end

  def expired?
    expires_at.past?
  end

  def refresh!
    response = Rails.configuration.x.twitter_token_client.post(
      grant_type: 'refresh_token',
      refresh_token:,
    )
    update!(
      refresh_token: response.body['refresh_token'],
      token: response.body['access_token'],
      expires_at: Time.zone.parse(response.headers['date']) + response.body['expires_in'],
    )
  end
end
