# frozen_string_literal: true

class ImportKadaisJob < ApplicationJob
  def perform(year: Kadai::YEARS)
    Array(year).each do |y|
      subjects = GenronSF::Subject.list(year: y)
      subjects.each do |subject|
        logger.info "Importing #{subject.year} 第#{subject.number}回"
        Kadai.import(subject)
      end
    end
  end
end
