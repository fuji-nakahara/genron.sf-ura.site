# frozen_string_literal: true

class TweetWorkSubmittedJob < ApplicationJob
  def perform(work)
    tweet = GenronSFFun::TwitterClient.instance.update(<<~TWEET)
      【#{work.class.model_name.human}】@#{work.student.user.twitter_screen_name}『#{work.title}』
      #裏SF創作講座
      https://genron-sf-fun.herokuapp.com/#{work.kadai.year}/#{work.kadai.round}
      #{work.url}
    TWEET

    work.update!(tweet_url: tweet.url)
  end
end
