# frozen_string_literal: true

class TweetDeadlineExpiredJob < ApplicationJob
  def perform(deadline)
    jissaku_expired_kadais = Kadai.where(jissaku_deadline: deadline)
    kougai_expired_kadais = Kadai.where(kougai_deadline: deadline)
    return if jissaku_expired_kadais.empty? && kougai_expired_kadais.empty?

    jissaku_expired_texts = jissaku_expired_kadais.map { |kadai| "第#{kadai.round}回実作" }
    kougai_expired_texts = kougai_expired_kadais.map { |kadai| "第#{kadai.round}回梗概" }
    tweet = <<~TWEET.chomp
      #{(jissaku_expired_texts + kougai_expired_texts).join('、')}締切です！
      #SF創作講座 #裏SF創作講座
    TWEET

    Sentry.with_scope do |scope|
      scope.set_extras(tweet_text: tweet)
      GenronSFFun::TwitterClient.instance.update(tweet)
    end
  end
end
