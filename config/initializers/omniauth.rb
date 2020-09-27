# frozen_string_literal: true

require 'omniauth/strategies/twitter_dev'

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter_dev if Rails.env.development?
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'], {
    secure_image_url: true,
    image_size: 'bigger',
  }
end

OmniAuth.config.logger = Rails.logger
