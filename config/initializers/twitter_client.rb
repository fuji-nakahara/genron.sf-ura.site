# frozen_string_literal: true

require 'twitter_client'
require 'twitter_client/token'

Rails.configuration.x.twitter_client = TwitterClient.with_oauth1(
  consumer_key: ENV.fetch('TWITTER_CONSUMER_KEY', nil),
  consumer_secret: ENV.fetch('TWITTER_CONSUMER_SECRET', nil),
  access_token: ENV.fetch('TWITTER_ACCESS_TOKEN', nil),
  access_token_secret: ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET', nil),
)

Rails.configuration.x.twitter_token_client = TwitterClient::Token.new(
  client_id: ENV.fetch('TWITTER_CLIENT_ID', nil),
  client_secret: ENV.fetch('TWITTER_CLIENT_SECRET', nil),
)
