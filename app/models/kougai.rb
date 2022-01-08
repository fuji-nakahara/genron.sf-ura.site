# frozen_string_literal: true

class Kougai < Work
  belongs_to :kadai, counter_cache: true

  class << self
    def import(work, kadai:)
      find_or_initialize_by(genron_sf_id: work.id).tap do |kougai|
        kougai.update!(
          kadai:,
          student: Student.import(work.student),
          title: work.summary_title.presence || '（タイトルなし）',
          url: work.url,
          score: 1,
        )
      end
    end
  end

  def serializable_hash(options = nil)
    default_options = { only: %i[id url genron_sf_id title selected] }
    super(default_options.merge(options.to_h))
  end
end
