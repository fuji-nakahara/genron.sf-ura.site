# frozen_string_literal: true

class Jissaku < Work
  belongs_to :kadai, counter_cache: true
  has_one :prize, dependent: :destroy

  scope :genron_sf_order, lambda {
    left_joins(:prize).joins(:student).order(
      Arel.sql("#{table_name}.genron_sf_id is null"),
      'prizes.position': :asc,
      score: :desc,
      selected: :desc,
      'students.genron_sf_id': :asc,
    )
  }

  class << self
    def import(work, kadai:)
      find_or_initialize_by(genron_sf_id: work.id).tap do |jissaku|
        jissaku.update!(
          kadai: kadai,
          student: Student.import(work.student),
          title: work.title,
          url: work.url,
        )
      end
    end
  end

  def serializable_hash(options = nil)
    default_options = { only: %i[id url genron_sf_id title selected score] }
    super(default_options.merge(options.to_h))
  end
end
