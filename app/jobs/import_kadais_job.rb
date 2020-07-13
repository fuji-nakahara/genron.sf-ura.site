# frozen_string_literal: true

class ImportKadaisJob < ApplicationJob
  def perform(*)
    Kadai::YEARS.each do |year|
      subjects = GenronSF::Subject.list(year: year)
      subjects.each do |subject|
        logger.info "Importing #{subject.year} 第#{subject.number}回"
        Kadai.import(subject)
      end
    end
  end
end
