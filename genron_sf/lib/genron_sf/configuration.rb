# frozen_string_literal: true

require 'logger'
require 'singleton'

module GenronSF
  class Configuration
    include Singleton

    class << self
      def default_logger
        Logger.new($stdout, progname: 'genron_sf')
      end
    end

    attr_accessor :logger

    def initialize
      @logger = self.class.default_logger
    end
  end
end
