# frozen_string_literal: true

class Kadai < ApplicationRecord
  YEARS = [2018, 2019].freeze
  LATEST_YEAR = YEARS.last

  has_many :kougais, dependent: :restrict_with_exception
  has_many :jissakus,
           -> { left_joins(:score).order('scores.value desc nulls last, created_at asc') },
           inverse_of: :kadai,
           dependent: :restrict_with_exception
  has_many :links, dependent: :delete_all

  scope :newest_order, -> { order(year: :desc, number: :desc) }
  scope :newest3, -> { newest_order.limit(3) }

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

  def kougai_deadline_time
    kougai_deadline&.in_time_zone&.end_of_day
  end

  def jissaku_deadline_time
    kougai_deadline&.in_time_zone&.end_of_day
  end

  def year_and_number
    "#{year} #{number_str}"
  end

  def number_str
    "第#{number}回"
  end

  def previous
    self.class.where('(year = ? and number < ?) or year < ?', year, number, year).newest_order.first
  end

  def next
    self.class.where('(year = ? and number > ?) or year > ?', year, number, year).newest_order.last
  end

  def genron_sf_url
    GenronSF::Subject.build_url(year: year, number: number)
  end

  def fetch_genron_sf_subject
    GenronSF::Subject.get(year: year, number: number)
  end
end
