# frozen_string_literal: true

class ImportSubjectsJob < ApplicationJob
  def perform(*)
    Subject::YEARS.each do |year|
      subjects = GenronSF::Subject.list(year: year)
      subjects.each do |subject|
        Subject.create_or_update_by!(subject)
      end
    end
  end
end
