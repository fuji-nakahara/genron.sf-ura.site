# frozen_string_literal: true

class ImportKougaisAndJissakusJob < ApplicationJob
  def perform(*) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    Kadai.all.find_each do |kadai|
      logger.info "Importing #{kadai.year} #{kadai.number}"
      subject = kadai.fetch_genron_sf_subject

      subject.summaries(force: true).each do |work|
        if work.summary_title
          Kougai.find_or_initialize_by(genron_sf_id: work.id).update!(
            kadai: kadai,
            student: Student.create_or_update_by!(work.student),
            title: work.summary_title,
            url: work.url,
          )
        end
        if work.title
          Jissaku.find_or_initialize_by(genron_sf_id: work.id).update!(
            kadai: kadai,
            student: Student.create_or_update_by!(work.student),
            title: work.title,
            url: work.url,
          )
        end
      end

      subject.scores.each do |score|
        jissaku = Jissaku.find_by(genron_sf_id: score.work.id)
        Score.create!(jissaku: jissaku, value: score.value) if jissaku && score.value.positive?
      end
    end
  end
end
