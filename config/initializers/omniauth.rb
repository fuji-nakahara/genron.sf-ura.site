# frozen_string_literal: true

require 'omniauth/strategies/twitter_dev'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter_dev if Rails.env.development?
  provider :twitter, ENV.fetch('TWITTER_KEY', nil), ENV.fetch('TWITTER_SECRET', nil), {
    secure_image_url: true,
    image_size: 'bigger',
  }
end

OmniAuth.config.logger = Rails.logger
