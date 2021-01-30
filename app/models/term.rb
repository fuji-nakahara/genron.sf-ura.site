# frozen_string_literal: true

class Term < ApplicationRecord
  self.primary_key = :year

  has_many :kadais, primary_key: :year, foreign_key: :year, dependent: :restrict_with_exception, inverse_of: :term
end
