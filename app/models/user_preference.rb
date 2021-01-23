# frozen_string_literal: true

class UserPreference
  include ActiveModel::Model
  include ActiveModel::Attributes
  include ActiveModel::Serializers::JSON

  attribute :works_order, :string, default: 'default'

  validates :works_order, inclusion: { in: %w[default genron_sf] }

  def persisted?
    true
  end
end
