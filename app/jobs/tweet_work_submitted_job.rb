# frozen_string_literal: true

class TweetWorkSubmittedJob < ApplicationJob
  def perform(work)
    raise "Kadai tweet_id is missing: #{work.kadai.id}" if work.kadai.tweet_id.nil?

    text = <<~TWEET
      #{work.class.model_name.human}が投稿されました！
      @#{work.student.user.twitter_screen_name}『#{work.title}』
      #裏SF創作講座
    TWEET
    tweet = Rails.configuration.x.twitter_client.tweet(text, reply_to: work.kadai.tweet_id)

    work.update!(tweet_id: tweet.fetch('data').fetch('id'))
  end
end
