# frozen_string_literal: true

FactoryBot.define do
  factory :kadai do
    term
    sequence(:round)
    title { '『これがSFだ！』という短編を書きなさい' }
    author { '大森望' }
    kougai_deadline { 2.months.ago }
    jissaku_deadline { 1.month.ago }
    sequence(:tweet_url) { |n| "https://twitter.com/genron_sf_fun/status/#{n}" }
  end
end
