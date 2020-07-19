# frozen_string_literal: true

class Link < ApplicationRecord
  belongs_to :kadai
  belongs_to :user, optional: true

  validates :url, format: /\A#{URI.regexp(%w[http https])}\z/
  validate :contain_open_graph, on: :create

  def url_domain
    URI.parse(url).host
  end

  private

  def contain_open_graph
    object = OpenGraphReader.fetch!(url)
    assign_attributes(url: object.og.url, title: object.og.title)
  rescue OpenGraphReader::NoOpenGraphDataError
    errors.add(:base, 'タイトルの取得に失敗しました')
  end
end
