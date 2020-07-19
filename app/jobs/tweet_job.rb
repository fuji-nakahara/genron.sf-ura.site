# frozen_string_literal: true

class TweetJob < ApplicationJob
  def perform(status)
    GenronSFFun::TwitterClient.instance.update(status)
  end
end
