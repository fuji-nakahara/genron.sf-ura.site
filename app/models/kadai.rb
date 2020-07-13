# frozen_string_literal: true

class Kadai < ApplicationRecord
  YEARS = [2016, 2017, 2018, 2019].freeze
  LATEST_YEAR = YEARS.last

  scope :newest_order, -> { order(year: :desc, number: :desc) }

  class << self
    def import(subject)
      find_or_initialize_by(year: subject.year, number: subject.number).tap do |kadai|
        kadai.update!(
          title: subject.theme,
          author: subject.lecturers.find { |lecturer| lecturer.roles.include?('課題提示') }&.name,
          kougai_deadline: subject.summary_deadline,
          jissaku_deadline: subject.work_deadline,
        )
      end
    end
  end

  def fetch_genron_sf_subject
    GenronSF::Subject.get(year: year, number: number)
  end
end
