# frozen_string_literal: true

class ImportStudentsJob < ApplicationJob
  def perform(year: Kadai::YEARS)
    Array(year).each do |y|
      students = GenronSF::Student.list(year: y)
      students.each do |student|
        logger.info "Importing #{y} #{student.id}"
        Student.import(student)
      end
    end
  end
end
