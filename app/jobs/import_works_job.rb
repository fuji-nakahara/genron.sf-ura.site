# frozen_string_literal: true

class ImportWorksJob < ApplicationJob
  def perform(kadais: Kadai.all) # rubocop:disable Metrics/AbcSize
    kadais.each do |kadai|
      subject = kadai.fetch_genron_sf_subject

      subject.summaries.each do |work|
        logger.info "Importing summary: #{kadai.year} #{work.student.id} #{work.id}"
        Kougai.import(work, kadai: kadai) unless Kougai.exists?(genron_sf_id: work.id)
      end

      subject.works.each do |work|
        logger.info "Importing work: #{kadai.year} #{work.student.id} #{work.id}"
        Jissaku.import(work, kadai: kadai) unless Jissaku.exists?(genron_sf_id: work.id)
      end

      logger.info "Importing scores: #{kadai.year_and_number}"
      subject.scores.each do |score|
        jissaku = Jissaku.find_by(genron_sf_id: score.work.id)
        next if jissaku.nil?

        jissaku.build_score if jissaku.score.nil?
        jissaku.score.update!(value: score.value) if score.value.positive?
      end
    end
  end
end
