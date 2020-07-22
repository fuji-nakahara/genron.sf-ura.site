# frozen_string_literal: true

require_relative 'resource'
require_relative 'subject'

module GenronSF
  class SubjectList < Resource
    include Enumerable

    class << self
      def build_url(year:)
        "#{Resource::BASE_URL}#{year}/"
      end
    end

    attr_reader :year

    def initialize(year:)
      @year = year.to_i
      super(self.class.build_url(year: @year))
    end

    def each(&block)
      subjects.each(&block)
    end

    private

    def subjects
      @subjects ||= main.css('.theme-header').reverse.map do |header_element|
        Subject.new(year: year, header_element: header_element)
      end
    end
  end
end
