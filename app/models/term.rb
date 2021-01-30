# frozen_string_literal: true

class Term < ApplicationRecord
  self.primary_key = :year

  has_many :kadais, -> { order(round: :desc) },
           primary_key: :year, foreign_key: :year, dependent: :restrict_with_exception, inverse_of: :term

  scope :latest, -> { order(year: :desc).limit(1) }

  def self.latest_year
    latest.pick(:year)
  end

  def genron_sf_subjects_url
    GenronSF::SubjectList.build_url(year: year)
  end

  def genron_sf_students_url
    GenronSF::StudentList.build_url(year: year)
  end

  def genron_sf_scores_url
    GenronSF::ScoreTable.build_url(year: year)
  end
end
