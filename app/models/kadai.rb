# frozen_string_literal: true

class Kadai < ApplicationRecord
  YEARS = [2016, 2017, 2018, 2019].freeze
  LATEST_YEAR = YEARS.last

  class << self
    def create_or_update_by!(subject)
      find_or_initialize_by(year: subject.year, number: subject.number).update!(
        title: subject.theme,
        kougai_deadline: subject.summary_deadline,
        jissaku_deadline: subject.work_deadline,
      )
    end
  end
end
