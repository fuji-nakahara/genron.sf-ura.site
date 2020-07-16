# frozen_string_literal: true

class Student < ApplicationRecord
  has_many :kougais, dependent: :restrict_with_exception
  has_many :jissakus, dependent: :restrict_with_exception
  has_one :student_twitter_candidate,
          dependent: :destroy, primary_key: :genron_sf_id, foreign_key: :genron_sf_id, inverse_of: :student
  has_one :user, dependent: :restrict_with_exception

  class << self
    def import(genron_sf_student)
      find_or_initialize_by(genron_sf_id: genron_sf_student.id).tap do |student|
        student.update!(
          name: genron_sf_student.name,
          url: genron_sf_student.url,
        )
      end
    end
  end
end
