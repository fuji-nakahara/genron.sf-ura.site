# frozen_string_literal: true

class Student < ApplicationRecord
  before_destroy :unable_to_destroy_imported_student

  has_many :kougais, dependent: :destroy
  has_many :jissakus, dependent: :destroy
  has_many :works, dependent: :delete_all
  has_one :user, dependent: :restrict_with_exception

  validates :name, presence: true, length: { maximum: 50 }
  validates :url, presence: true, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/ }
  validates :description, length: { maximum: 300 }

  scope :with_votes_sum, lambda {
    joins(:works)
      .select(
        'students.*',
        "sum(case when works.type = 'Kougai' then works.votes_count else 0 end) as kougai_votes_sum",
        "sum(case when works.type = 'Jissaku' then works.votes_count else 0 end) as jissaku_votes_sum",
        'sum(works.votes_count) as votes_sum',
      )
      .group(:id)
      .having('sum(works.votes_count) > 0')
  }

  class << self
    def import(genron_sf_student)
      find_or_initialize_by(genron_sf_id: genron_sf_student.id).tap do |student|
        student.update!(
          name: genron_sf_student.name,
          url: genron_sf_student.url,
        )
      end
    end
  end

  def to_param
    genron_sf_id || id.to_s
  end

  def url_domain
    URI.parse(url).host
  end

  private

  def unable_to_destroy_imported_student
    if genron_sf_id
      errors.add(:base, '超・SF作家育成サイトからインポートした受講生は削除できません')
      throw :abort
    end
  end
end
