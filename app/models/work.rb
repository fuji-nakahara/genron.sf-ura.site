# frozen_string_literal: true

class Work < ApplicationRecord
  before_destroy :unable_to_destroy_imported_work

  belongs_to :kadai
  belongs_to :student
  has_many :votes, dependent: :delete_all
  has_many :ordered_votes, -> { order(:created_at) }, class_name: 'Vote', inverse_of: :work # rubocop:disable Rails/HasManyOrHasOneDependent
  has_many :voters, through: :ordered_votes, source: :user

  validates :title, presence: true
  validates :url, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/ }
  validate :url_is_not_kakuyomu_workspace

  scope :stats_by_year, lambda {
    joins(:kadai)
      .select(
        :'kadais.year',
        "count(case when works.type = 'Kougai' then 1 else null end) as kougais_count",
        "count(case when works.type = 'Jissaku' then 1 else null end) as jissakus_count",
        'sum(works.votes_count) as votes_sum',
      )
      .group(:'kadais.year')
      .order(:'kadais.year')
  }

  private

  def unable_to_destroy_imported_work
    return if genron_sf_id.nil?

    errors.add(:base, '超・SF作家育成サイトからインポートした作品は削除できません')
    throw :abort
  end

  def url_is_not_kakuyomu_workspace
    errors.add(:url, 'がカクヨムの編集用URLになっています。公開用URLを入力してください') if url.start_with?('https://kakuyomu.jp/my')
  end
end
