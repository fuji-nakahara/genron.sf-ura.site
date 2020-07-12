# frozen_string_literal: true

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
      @year = year
      super(self.class.build_url(year: year))
    end

    def each(&block)
      to_a.each(&block)
    end

    def to_a
      subjects
    end

    private

    def subjects
      @subjects ||= main.css('.theme-header').map do |header_element|
        Subject.new(year: year, header_element: header_element)
      end
    end
  end
end
