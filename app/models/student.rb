# frozen_string_literal: true

class Student < ApplicationRecord
  has_many :kougais, dependent: :destroy
  has_many :jissakus, dependent: :destroy
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
