# frozen_string_literal: true

class Student < ApplicationRecord
  class << self
    def create_or_update_by!(genron_sf_student)
      find_or_initialize_by(genron_sf_id: genron_sf_student.id).tap do |student|
        student.update!(name: genron_sf_student.name)
      end
    end
  end
end
