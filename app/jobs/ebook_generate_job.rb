# frozen_string_literal: true

class EBookGenerateJob < ApplicationJob
  def perform(year:, genron_sf_student_id:, email:)
    path = Rails.root.join("tmp/genron_sf-#{year}-#{genron_sf_student_id}.epub")
    GenronSF::EBook.generate_student(year: year, id: genron_sf_student_id, path: path)
    UserMailer.ebook(email: email, ebook_path: path.to_s).deliver_now
  end
end
