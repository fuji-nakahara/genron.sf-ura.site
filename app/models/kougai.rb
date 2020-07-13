# frozen_string_literal: true

class Kougai < Work
  class << self
    def import(kadai, student, work)
      find_or_initialize_by(genron_sf_id: work.id).tap do |kougai|
        kougai.update!(
          kadai: kadai,
          student: student,
          title: work.summary_title,
          url: work.url,
        )
      end
    end
  end
end
