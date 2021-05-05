# frozen_string_literal: true

class Jissaku < Work
  belongs_to :kadai, counter_cache: true
  has_one :prize, dependent: :destroy

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
