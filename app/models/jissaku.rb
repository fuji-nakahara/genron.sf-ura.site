# frozen_string_literal: true

class Jissaku < Work
  self.ignored_columns = %i[selected]

  has_one :prize, dependent: :destroy

  scope :default_order, lambda {
    left_joins(:prize).order('prizes.position asc nulls last', score: :desc, votes_count: :desc, created_at: :asc)
  }
  scope :genron_sf_order, lambda {
    left_joins(:prize).joins(:student).order(
      Arel.sql("#{table_name}.genron_sf_id is null"),
      'prizes.position asc nulls last',
      score: :desc,
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
end
