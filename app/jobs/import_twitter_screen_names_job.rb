# frozen_string_literal: true

class ImportTwitterScreenNamesJob < ApplicationJob
  def perform(year: Term.latest_year)
    Array(year).each do |y|
      students = GenronSF::Student.list(year: y)
      students.each do |genron_sf_student|
        logger.info "Importing #{y} #{genron_sf_student.id}"
        student = Student.import(genron_sf_student)
        next unless (twitter_screen_name = genron_sf_student.twitter_screen_name)

        candidate = StudentTwitterCandidate.find_or_initialize_by(genron_sf_id: genron_sf_student.id)
        candidate.update!(twitter_screen_name:)
        next if candidate.previous_changes.empty?

        user = User.joins(:student).merge(Student.where(genron_sf_id: nil))
                   .find_by(twitter_screen_name:)
        next if user.nil?

        Sentry.capture_message(
          'ユーザーが受講生プロフィールにTwitterアカウントを載せた可能性があります',
          level: :info,
          extra: {
            genron_sf_url: genron_sf_student.url,
            twitter_url: "https://twitter.com/#{twitter_screen_name}",
          },
          hint: { background: false },
        )

        user.student_merge_candidates.create!(student:)
      end
    end
  end
end
