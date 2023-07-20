# frozen_string_literal: true

require 'faraday'

require_relative 'middleware/raise_error'

class TwitterClient
  class Token
    def initialize(client_id:, client_secret:)
      @conn = Faraday.new(url: 'https://api.twitter.com/2/oauth2/token') do |conn|
        conn.request :authorization, :basic, client_id, client_secret
        conn.request :url_encoded
        conn.response :json
        conn.use Middleware::RaiseError
        conn.response :logger, nil, { headers: false }
      end
    end

    def post(**params)
      @conn.post(nil, params)
    end
  end
end
