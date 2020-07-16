# frozen_string_literal: true

FactoryBot.define do
  factory :student do
    sequence(:genron_sf_id) { |n| "student_#{n}" }
    name { 'フジ・ナカハラ' }
    url { 'http://example.com/student' }
  end
end
