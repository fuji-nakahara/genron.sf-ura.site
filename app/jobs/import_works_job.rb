# frozen_string_literal: true

class ImportWorksJob < ApplicationJob
  def perform(kadais: Kadai.newest3)
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
        ids = subject.excellent_entries.map(&:id)
        Work.where(type: %w[Kougai Jissaku], genron_sf_id: ids, selected: false).each do |work|
          work.update!(selected: true)
        end
      end

      logger.info "Importing scores: #{subject.url}"
      results = subject.scores.map do |score|
        Jissaku.where(genron_sf_id: score.work.id).where.not(score: score).take&.update!(score: score)
      end
      Rails.cache.delete("score_table/#{subject.year}") if results.any?
    end
  end
end
