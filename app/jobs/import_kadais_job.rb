# frozen_string_literal: true

class ImportKadaisJob < ApplicationJob
  def perform(year:)
    Array(year).each do |y|
      subjects = GenronSF::Subject.list(year: y)
      subjects.each do |subject|
        logger.info "Importing #{subject.url}"
        Kadai.import(subject)
      end
    end
  end
end
