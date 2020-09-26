# frozen_string_literal: true

class StudentTwitterCandidate < ApplicationRecord
  belongs_to :student, foreign_key: :genron_sf_id, primary_key: :genron_sf_id # rubocop:disable Rails/InverseOf
end
