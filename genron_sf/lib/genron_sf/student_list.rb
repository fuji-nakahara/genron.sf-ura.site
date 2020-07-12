# frozen_string_literal: true

module GenronSF
  class StudentList < Resource
    include Enumerable

    class << self
      def build_url(year:)
        "#{Resource::BASE_URL}#{year}/students/"
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
      students
    end

    private

    def students
      @students ||= main.css('.student-list-item a').map do |element|
        Student.new(url: element['href'], name: element.at_css('.name').content.strip)
      end
    end
  end
end
