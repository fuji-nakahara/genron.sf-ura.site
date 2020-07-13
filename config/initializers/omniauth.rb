# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :developer unless Rails.env.production?
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET'], {
    secure_image_url: true,
    image_size: 'bigger',
  }
end

OmniAuth.config.logger = Rails.logger
