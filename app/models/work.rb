# frozen_string_literal: true

class Work < ApplicationRecord
  belongs_to :kadai, counter_cache: true
  belongs_to :student, counter_cache: true
end
