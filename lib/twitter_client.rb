# frozen_string_literal: true

require 'faraday'
require 'simple_oauth'

require_relative 'twitter_client/middleware/oauth'
require_relative 'twitter_client/middleware/raise_error'

class TwitterClient
  BASE_URL = 'https://api.twitter.com/'

  def self.with_oauth1(consumer_key:, consumer_secret:, access_token:, access_token_secret:)
    connection = Faraday.new(url: BASE_URL) do |conn|
      conn.use Middleware::OAuth, oauth: {
        consumer_key:,
        consumer_secret:,
        token: access_token,
        token_secret: access_token_secret,
      }
    end

    new(connection)
  end

  def self.with_oauth2(bearer_token:)
    connection = Faraday.new(url: BASE_URL) do |conn|
      conn.request :authorization, 'Bearer', bearer_token
    end

    new(connection)
  end

  def initialize(connection)
    @conn = connection.tap do |conn|
      conn.request :json
      conn.response :json
      conn.use Middleware::RaiseError
      conn.response :logger, nil, { headers: false, bodies: { request: false, response: true } }
    end
  end

  def tweet(text)
    response = @conn.post('/2/tweets', { text: })
    response.body
  end

  def me(params)
    response = @conn.get('/2/users/me', params)
    response.body
  end
end
