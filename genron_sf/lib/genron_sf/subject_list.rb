# frozen_string_literal: true

module GenronSF
  class SubjectList < Resource
    include Enumerable

    attr_reader :year

    def initialize(year:)
      @year = year
      super("#{BASE_URL}#{year}/")
    end

    def each(&block)
      to_a.each(&block)
    end

    def to_a
      subjects
    end

    private

    def subjects
      @subjects ||= doc.css('#main header.theme-header').map do |header_element|
        Subject.new(year: year, number: header_element.at_css('.number').content[/\d+/].to_i).tap do |subject|
          subject.header_element = header_element
        end
      end
    end
  end
end
