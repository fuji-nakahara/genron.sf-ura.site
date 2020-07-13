# frozen_string_literal: true

class Student < ApplicationRecord
  class << self
    def import(genron_sf_student)
      find_or_initialize_by(genron_sf_id: genron_sf_student.id).tap do |student|
        student.update!(name: genron_sf_student.name)
      end
    end
  end

  def genron_sf_url(year:)
    GenronSF::Student.build_url(year: year, id: genron_sf_id)
  end
end
