# frozen_string_literal: true

class Jissaku < Work
  self.ignored_columns = %i[selected]

  has_one :prize, dependent: :destroy

  scope :default_order, lambda {
    left_joins(:prize).order('prizes.position asc nulls last, score desc, votes_count desc, created_at asc')
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
