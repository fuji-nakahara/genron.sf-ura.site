# frozen_string_literal: true

class TweetWorkSubmittedJob < ApplicationJob
  def perform(work)
    tweet = Rails.configuration.x.twitter_client.tweet(<<~TWEET)
      【#{work.class.model_name.human}】@#{work.student.user.twitter_screen_name}『#{work.title}』
      #裏SF創作講座
      https://genron.sf-ura.site/#{work.kadai.year}/#{work.kadai.round}
      #{work.url}
    TWEET

    work.update!(tweet_id: tweet.fetch('data').fetch('id'))
  end
end
