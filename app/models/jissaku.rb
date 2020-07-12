# frozen_string_literal: true

class Jissaku < ApplicationRecord
  belongs_to :kadai
  belongs_to :student
end
