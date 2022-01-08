# frozen_string_literal: true

class EBookGenerateJob < ApplicationJob
  def perform(year:, student:, email:)
    path = Rails.root.join("tmp/genron_sf-#{year}-#{student.genron_sf_id}.epub")
    GenronSF::EBook.generate_student(year:, id: student.genron_sf_id, path:)
    UserMailer.ebook(student:, email:, ebook_path: path.to_s).deliver_now
  end
end
