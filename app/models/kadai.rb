# frozen_string_literal: true

class Kadai < ApplicationRecord
  YEARS = [2016, 2017, 2018, 2019].freeze
  LATEST_YEAR = YEARS.last

  class << self
    def create_or_update_by!(subject)
      find_or_initialize_by(year: subject.year, number: subject.number).tap do |kadai|
        kadai.update!(
          title: kadai.theme,
          kougai_deadline: kadai.summary_deadline,
          jissaku_deadline: kadai.work_deadline,
        )
      end
    end
  end

  def fetch_genron_sf_subject
    GenronSF::Subject.get(year: year, number: number)
  end
end
