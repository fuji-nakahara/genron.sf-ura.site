# frozen_string_literal: true

FactoryBot.define do
  factory :kougai do
    kadai
    student
    sequence(:genron_sf_id)
    title { '式年遷皇' }
    url { 'http://example.com/kougai' }
    sequence(:tweet_id)
  end
end
