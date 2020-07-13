# frozen_string_literal: true

class Jissaku < Work
  has_one :score, dependent: :destroy

  class << self
    def import(kadai, student, work)
      find_or_initialize_by(genron_sf_id: work.id).tap do |jissaku|
        jissaku.update!(
          kadai: kadai,
          student: student,
          title: work.title,
          url: work.url,
        )
      end
    end
  end
end
