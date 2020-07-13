# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    student
    sequence(:twitter_id)
    url { 'http://example.com/user' }
    image_url { 'http://example.com/user/image' }
    twitter_screen_name { 'twitter_screen_name' }
    last_logged_in_at { Time.zone.now }
  end
end
