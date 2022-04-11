# frozen_string_literal: true

FactoryBot.define do
  factory :draft do
    student
    kind { :kougai }
    title { 'Identity Disconnect' }
    url { 'http://example.com/draft' }
    comment { '感想はツイッターのDMでください。' }
    sequence(:tweet_url) { |n| "https://twitter.com/genron_sf_fun/status/#{n}" }
  end
end
