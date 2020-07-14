# frozen_string_literal: true

class StudentTwitterCandidate < ApplicationRecord
  belongs_to :student, foreign_key: :genron_sf_id, primary_key: :genron_sf_id, inverse_of: :student_twitter_candidate
end
