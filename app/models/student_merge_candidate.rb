# frozen_string_literal: true

class StudentMergeCandidate < ApplicationRecord
  belongs_to :student
  belongs_to :user
end
