# frozen_string_literal: true

module GenronSFFun
  class TwitterClient < Twitter::REST::Client
    include Singleton

    def initialize
      @consumer_key = ENV.fetch('TWITTER_CONSUMER_KEY')
      @consumer_secret = ENV.fetch('TWITTER_CONSUMER_SECRET')
      @access_token = ENV.fetch('TWITTER_ACCESS_TOKEN')
      @access_token_secret = ENV.fetch('TWITTER_ACCESS_TOKEN_SECRET')
      super
    end

    def update(*)
      tweet_v2(*)
    end
  end
end
