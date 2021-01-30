# frozen_string_literal: true

class ImportStudentsJob < ApplicationJob
  def perform(year:)
    Array(year).each do |y|
      students = GenronSF::Student.list(year: y)
      students.each do |student|
        logger.info "Importing #{student.url}"
        Student.import(student)
      end
    end
  end
end
