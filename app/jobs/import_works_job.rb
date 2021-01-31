# frozen_string_literal: true

class ImportWorksJob < ApplicationJob
  def perform(kadais: Kadai.all)
    kadais.each do |kadai|
      subject = kadai.fetch_genron_sf_subject

      subject.summaries.each do |work|
        next if Kougai.exists?(genron_sf_id: work.id)

        logger.info "Importing summary: #{work.url}"
        Kougai.import(work, kadai: kadai)
      end

      subject.works.each do |work|
        next if Jissaku.exists?(genron_sf_id: work.id)

        logger.info "Importing work: #{work.url}"
        Jissaku.import(work, kadai: kadai)
      end

      if subject.work_comment_date && Time.zone.today < subject.work_comment_date
        logger.info "Importing selected: #{subject.url}"
        subject.excellent_entries.each do |work|
          Work.where(genron_sf_id: work.id).each do |w|
            w.update!(selected: true)
          end
        end
      end

      logger.info "Importing scores: #{subject.url}"
      subject.scores.each do |score|
        Jissaku.find_by(genron_sf_id: score.work.id)&.update!(score: score.value)
      end
    end
  end
end
