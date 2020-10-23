# frozen_string_literal: true

class Kougai < Work
  has_one :election, dependent: :destroy

  scope :default_order, -> { left_joins(:election).order('(elections.id is null), votes_count desc, created_at asc') }

  class << self
    def import(work, kadai:)
      find_or_initialize_by(genron_sf_id: work.id).tap do |kougai|
        kougai.update!(
          kadai: kadai,
          student: Student.import(work.student),
          title: work.summary_title || '（タイトルなし）',
          url: work.url,
        )
      end
    end
  end
end
