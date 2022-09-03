# frozen_string_literal: true

require 'omniauth/strategies/twitter_dev'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter_dev if Rails.env.development?
  provider :twitter2, ENV.fetch('TWITTER_CLIENT_ID', nil), ENV.fetch('TWITTER_CLIENT_SECRET', nil),
           scope: 'tweet.read users.read'
end

OmniAuth.config.logger = Rails.logger
