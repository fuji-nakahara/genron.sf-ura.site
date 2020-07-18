# frozen_string_literal: true

class TwitterFollowJob < ApplicationJob
  def perform(twitter_id)
    GenronSFFun::TwitterClient.instance.follow!(twitter_id)
  end
end
