# frozen_string_literal: true

class Draft < ApplicationRecord
  belongs_to :student

  enum :kind, kougai: 0, jissaku: 1

  validates :kind, presence: true
  validates :title, presence: true
  validates :url, format: /\A#{URI::DEFAULT_PARSER.make_regexp(%w[http https])}\z/
  validates :comment, length: { maximum: 140 }

  def kind_ja
    case kind
    when 'jissaku'
      '実作'
    else
      '梗概'
    end
  end
end
