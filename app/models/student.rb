# frozen_string_literal: true

class Student < ApplicationRecord
  before_destroy :unable_to_destroy_imported_student

  has_many :kougais, dependent: :destroy
  has_many :jissakus, dependent: :destroy
  has_one :student_twitter_candidate,
          dependent: :destroy, primary_key: :genron_sf_id, foreign_key: :genron_sf_id, inverse_of: :student
  has_one :user, dependent: :restrict_with_exception

  class << self
    def import(genron_sf_student)
      find_or_initialize_by(genron_sf_id: genron_sf_student.id).tap do |student|
        student.update!(
          name: genron_sf_student.name,
          url: genron_sf_student.url,
        )
      end
    end
  end

  private

  def unable_to_destroy_imported_student
    return if genron_sf_id.nil?

    errors.add(:base, '超・SF作家育成サイトからインポートした受講生は削除できません')
    throw :abort
  end
end
