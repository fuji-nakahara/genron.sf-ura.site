# frozen_string_literal: true

class ImportWorksJob < ApplicationJob
  def perform(kadais: Kadai.all) # rubocop:disable Metrics/AbcSize
    kadais.each do |kadai|
      subject = kadai.fetch_genron_sf_subject

      subject.summaries(force: true).each do |work|
        logger.info "Importing #{kadai.year} #{work.student.id} #{work.id}"
        student = Student.import(work.student)
        Kougai.import(kadai, student, work) if work.summary_title
        Jissaku.import(kadai, student, work) if work.title
      end

      logger.info "Importing #{kadai.year_and_number} scores"
      subject.scores.each do |score|
        jissaku = Jissaku.find_by(genron_sf_id: score.work.id)
        jissaku.create_score!(value: score.value) if jissaku && jissaku.score.nil? && score.value.positive?
      end
    end
  end
end
