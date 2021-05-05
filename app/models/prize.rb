# frozen_string_literal: true

class Prize < ApplicationRecord
  belongs_to :jissaku

  def serializable_hash(options = nil)
    default_options = { only: %i[title position] }
    super(default_options.merge(options.to_h))
  end
end
