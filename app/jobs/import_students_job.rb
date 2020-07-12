# frozen_string_literal: true

class ImportStudentsJob < ApplicationJob
  def perform(*)
    Kadai::YEARS.each do |year|
      students = GenronSF::Student.list(year: year)
      students.each do |student|
        Student.create_or_update_by!(student)
      end
    end
  end
end
