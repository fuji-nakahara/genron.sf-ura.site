# frozen_string_literal: true

class Jissaku < ApplicationRecord
  belongs_to :subject
  belongs_to :student
end
