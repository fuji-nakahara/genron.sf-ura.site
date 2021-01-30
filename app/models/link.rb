# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :kadai
  belongs_to :user, optional: true

  validates :url, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validate :has_title_or_contains_open_graph, on: :create

  def url_host
    URI.parse(url).host
  end

  private

  def has_title_or_contains_open_graph # rubocop:disable Naming/PredicateName
    return if title.present?

    object = OpenGraphReader.fetch!(url)
    self.title = object.og.title
  rescue OpenGraphReader::NoOpenGraphDataError
    errors.add(:base, 'タイトルの取得に失敗しました')
  end
end
