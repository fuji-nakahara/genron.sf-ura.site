# frozen_string_literal: true

class Work < ApplicationRecord
  before_destroy :unable_to_destroy_imported_work

  belongs_to :kadai, counter_cache: true
  belongs_to :student, counter_cache: true
  has_many :votes, dependent: :delete_all
  has_many :voters, through: :votes, source: :user

  validates :title, presence: true
  validates :url, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  def url_domain
    URI.parse(url).host
  end

  private

  def unable_to_destroy_imported_work
    return if genron_sf_id.nil?

    errors.add(:base, '超・SF作家育成サイトからインポートした作品は削除できません')
    throw :abort
  end
end
