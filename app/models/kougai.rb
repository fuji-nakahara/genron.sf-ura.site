# frozen_string_literal: true

class Kougai < ApplicationRecord
  belongs_to :subject
  belongs_to :student
end
