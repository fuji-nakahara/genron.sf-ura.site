# frozen_string_literal: true

require_relative 'genron_sf/configuration'
require_relative 'genron_sf/score_table'
require_relative 'genron_sf/student'
require_relative 'genron_sf/subject'
require_relative 'genron_sf/term'
require_relative 'genron_sf/version'
require_relative 'genron_sf/work'

module GenronSF
  def self.config
    Configuration.instance
  end

  def self.logger
    config.logger
  end
end
