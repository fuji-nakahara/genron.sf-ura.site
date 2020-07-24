# frozen_string_literal: true

class EBookForm
  include ActiveModel::Model

  attr_accessor :student, :year, :email, :accept_generating_ebook

  validates :year, presence: true, inclusion: { in: Kadai::YEARS.map(&:to_s) }
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :accept_generating_ebook, presence: true, acceptance: true

  def available_years
    return [] if student.nil?

    Kadai
      .joins(works: :student)
      .merge(Work.where.not(genron_sf_id: nil))
      .merge(Student.where(id: student.id))
      .order(year: :desc)
      .distinct.pluck(:year)
  end
end
