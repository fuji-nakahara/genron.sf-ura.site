# frozen_string_literal: true

FactoryBot.define do
  factory :student do
    sequence(:genron_sf_id) { |n| "student_#{n}" }
    name { 'フジ・ナカハラ' }

    trait :informal do
      user
      genron_sf_id { nil }
    end
  end
end
