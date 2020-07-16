# frozen_string_literal: true

FactoryBot.define do
  factory :vote do
    user
    work factory: :kougai
  end
end
