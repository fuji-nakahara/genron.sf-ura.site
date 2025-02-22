# frozen_string_literal: true

class Kadai < ApplicationRecord
  belongs_to :term, foreign_key: :year, primary_key: :year, inverse_of: :kadais

  has_many :works, dependent: :restrict_with_exception
  has_many :kougais, dependent: :restrict_with_exception
  has_many :jissakus, dependent: :restrict_with_exception
  has_many :links, dependent: :delete_all

  scope :newest_order, -> { order(year: :desc, round: :desc) }
  scope :newest3, -> { newest_order.limit(3) }

  class << self
    def import(subject)
      find_or_initialize_by(year: subject.year, round: subject.number).tap do |kadai|
        kadai.update!(
          title: subject.theme,
          author: subject.lecturers.find { |lecturer| lecturer.roles.include?('課題提示') }&.name,
          kougai_deadline: subject.summary_deadline,
          jissaku_deadline: subject.work_deadline,
        )
      end
    end
  end

  def to_param
    round.to_s
  end

  def serializable_hash(options = nil)
    default_options = {
      only: %i[id year round title author kougai_deadline jissaku_deadline],
      methods: :url,
    }
    super(default_options.merge(options.to_h))
  end

  def kougai_deadline_time
    kougai_deadline&.in_time_zone&.end_of_day
  end

  def jissaku_deadline_time
    jissaku_deadline&.in_time_zone&.end_of_day
  end

  def human_year_round
    "#{year} #{human_round}"
  end

  def human_round
    "第#{round}回"
  end

  def previous
    self.class.where('(year = ? and round < ?) or year < ?', year, round, year).newest_order.first
  end

  def next
    self.class.where('(year = ? and round > ?) or year > ?', year, round, year).newest_order.last
  end

  def url
    GenronSF::Subject.build_url(year:, number: round)
  end

  def fetch_genron_sf_subject
    GenronSF::Subject.get(year:, number: round)
  rescue GenronSF::HTTPError => e
    # 2024年第7課題の URL が以下の従来と異なるフォーマットになっていることに対する一時的な対応
    # https://school.genron.co.jp/works/sf/2024/subjects/自分とまったくちがう思想を持つ人を語り手、あ/
    if e.message.include?('/2024/subjects/7')
      subject = GenronSF::Subject.new(year: year, number: round)
      subject.instance_variable_set(:@url, 'https://school.genron.co.jp/works/sf/2024/subjects/%e8%87%aa%e5%88%86%e3%81%a8%e3%81%be%e3%81%a3%e3%81%9f%e3%81%8f%e3%81%a1%e3%81%8c%e3%81%86%e6%80%9d%e6%83%b3%e3%82%92%e6%8c%81%e3%81%a4%e4%ba%ba%e3%82%92%e8%aa%9e%e3%82%8a%e6%89%8b%e3%80%81%e3%81%82/')
      subject.tap(&:doc)
    else
      raise
    end
  end
end
