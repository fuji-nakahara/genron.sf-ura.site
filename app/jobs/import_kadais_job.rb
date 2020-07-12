# frozen_string_literal: true

class ImportKadaisJob < ApplicationJob
  def perform(*)
    Kadai::YEARS.each do |year|
      subjects = GenronSF::Subject.list(year: year)
      subjects.each do |subject|
        Kadai.create_or_update_by!(subject)
      end
    end
  end
end
