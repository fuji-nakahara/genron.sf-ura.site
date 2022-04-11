# frozen_string_literal: true

class TweetDraftSubmittedJob < ApplicationJob
  def perform(draft)
    tweet = GenronSFFun::TwitterClient.instance.update(<<~TWEET)
      【下書き】@#{draft.student.user.twitter_screen_name}『#{draft.title}』
      #裏SF創作講座
      #{draft.url}
    TWEET

    draft.update!(tweet_url: tweet.url)
  end
end
