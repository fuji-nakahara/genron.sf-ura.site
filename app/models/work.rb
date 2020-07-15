# frozen_string_literal: true

class Work < ApplicationRecord
  belongs_to :kadai, counter_cache: true
  belongs_to :student, counter_cache: true
  has_many :votes, dependent: :delete_all
  has_many :voters, through: :votes, source: :user

  def url_domain
    URI.parse(url).host
  end
end
