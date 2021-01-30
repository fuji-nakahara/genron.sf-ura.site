# frozen_string_literal: true

FactoryBot.define do
  factory :term do
    sequence(:year) { |n| 2016 + (n - 1) }
  end
end
