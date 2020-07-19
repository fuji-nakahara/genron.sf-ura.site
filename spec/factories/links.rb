# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    kadai
    user
    url { 'https://example.com/link' }
    title { 'タイトル' }
  end
end
