# frozen_string_literal: true

class TweetVoteResultsJob < ApplicationJob
  def perform(kadai, type:)
    max_vote_count = kadai.works.where(type:).maximum(:votes_count)
    return if max_vote_count <= 1

    top_works = kadai.works.where(type:, votes_count: max_vote_count)
    tweet = <<~TWEET.chomp
      現時点での第#{kadai.round}回#{type.constantize.model_name.human}の最高得票作は
      #{top_works.map { |work| "#{work.student.name}『#{work.title}』" }.join("\n")}
      で#{max_vote_count}票です！
      #裏SF創作講座
      https://genron.sf-ura.site/#{kadai.year}/#{kadai.round}
    TWEET

    Sentry.with_scope do |scope|
      scope.set_extras(tweet_text: tweet)
      GenronSFFun::TwitterClient.instance.update(tweet)
    end
  end
end
