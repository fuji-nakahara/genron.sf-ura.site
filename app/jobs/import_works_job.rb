# frozen_string_literal: true

class ImportWorksJob < ApplicationJob
  def perform(*) # rubocop:disable Metrics/AbcSize
    Kadai.all.find_each do |kadai|
      subject = kadai.fetch_genron_sf_subject

      subject.summaries(force: true).each do |work|
        logger.info "Importing #{kadai.year} #{work.student.id} #{work.id}"
        student = Student.import(work.student)
        Kougai.import(kadai, student, work) if work.summary_title
        Jissaku.import(kadai, student, work) if work.title
      end

      logger.info "Importing #{kadai.year} 第#{kadai.number}回 scores"
      subject.scores.each do |score|
        jissaku = Jissaku.find_by(genron_sf_id: score.work.id)
        jissaku.create_score!(value: score.value) if jissaku && jissaku.score.nil? && score.value.positive?
      end
    end
  end
end
