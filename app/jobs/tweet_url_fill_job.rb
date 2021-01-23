# frozen_string_literal: true

class TweetUrlFillJob < ApplicationJob
  def perform
    twitter_client = GenronSFFun::TwitterClient.instance
    tweets = twitter_client.user_timeline(count: 200)
    tweets += twitter_client.user_timeline(count: 200, max_id: tweets.last.id - 1)

    Kadai.where(year: 2020).each do |kadai|
      logger.info "Searching 第#{kadai.number}回 課題 tweet..."
      tweet = tweets.find do |t|
        t.text.start_with?("【課題】 第#{kadai.number}回「#{kadai.title}」")
      end
      if tweet
        logger.info "Found: #{tweet.text}"
        kadai.update!(tweet_url: tweet) if tweet
      else
        logger.info 'Not Found'
      end
    end

    Work.joins(:kadai).merge(Kadai.where(year: 2020)).each do |work|
      logger.info "Searching #{work.class.model_name.human}『#{work.title}』 tweet..."
      tweet = tweets.find do |t|
        t.text.match?(/\A【#{work.class.model_name.human}】.*『#{work.title}』/)
      end
      if tweet
        logger.info "Found: #{tweet.text}"
        work.update!(tweet_url: tweet.url)
      else
        logger.info 'Not Found'
      end
    end
  end
end
