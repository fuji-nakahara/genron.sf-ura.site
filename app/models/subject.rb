# frozen_string_literal: true

class Subject < ApplicationRecord
  YEARS = [2016, 2017, 2018, 2019].freeze
  LATEST_YEAR = YEARS.last

  class << self
    def create_or_update_by!(subject)
      find_or_initialize_by(year: subject.year, number: subject.number).update!(
        title: subject.title,
        kougai_deadline: subject.kougai_deadline,
        jissaku_deadline: subject.jissaku_deadline,
      )
    end
  end
end
