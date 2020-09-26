# frozen_string_literal: true

class Student < ApplicationRecord
  before_destroy :unable_to_destroy_imported_student

  has_many :kougais, dependent: :destroy
  has_many :jissakus, dependent: :destroy
  has_one :user, dependent: :restrict_with_exception

  validates :name, presence: true, length: { maximum: 50 }
  validates :url, presence: true, format: { with: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/ }

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
    if genron_sf_id
      errors.add(:base, '超・SF作家育成サイトからインポートした受講生は削除できません')
      throw :abort
    end
  end
end
