# frozen_string_literal: true

class Kougai < ApplicationRecord
  belongs_to :kadai
  belongs_to :student
end
