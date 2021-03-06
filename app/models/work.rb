# frozen_string_literal: true

class Work < ApplicationRecord
  before_destroy :unable_to_destroy_imported_work

  belongs_to :kadai
  belongs_to :student
  has_many :votes, dependent: :delete_all
  has_many :voters, through: :votes, source: :user

  validates :title, presence: true
  validates :url, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/

  scope :default_order, -> { order(votes_count: :desc, created_at: :asc) }

  def serializable_hash(options = nil)
    default_options = { only: %i[id genron_sf_id title url selected score votes_count] }
    super(default_options.merge(options.to_h))
  end

  def url_host
    URI.parse(url).host
  end

  private

  def unable_to_destroy_imported_work
    return if genron_sf_id.nil?

    errors.add(:base, '超・SF作家育成サイトからインポートした作品は削除できません')
    throw :abort
  end
end
