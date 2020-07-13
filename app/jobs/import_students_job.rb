# frozen_string_literal: true

class ImportStudentsJob < ApplicationJob
  def perform(*)
    Kadai::YEARS.each do |year|
      students = GenronSF::Student.list(year: year)
      students.each do |student|
        logger.info "Importing #{year} #{student.id}"
        Student.import(student)
      end
    end
  end
end
