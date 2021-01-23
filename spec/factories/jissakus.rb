# frozen_string_literal: true

FactoryBot.define do
  factory :jissaku do
    kadai
    student
    sequence(:genron_sf_id)
    title { 'リアル・サイボーグ' }
    url { 'http://example.com/jissaku' }
    sequence(:tweet_url) { |n| "https://twitter.com/genron_sf_fun/status/#{n}" }
  end
end
