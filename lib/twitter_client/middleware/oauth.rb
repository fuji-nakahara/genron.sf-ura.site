# frozen_string_literal: true

class TwitterClient
  module Middleware
    class OAuth < Faraday::Middleware
      def on_request(env)
        env[:request_headers]['Authorization'] = SimpleOAuth::Header.new(
          env[:method],
          env[:url].to_s,
          {},
          options[:oauth],
        ).to_s
      end
    end
  end
end
