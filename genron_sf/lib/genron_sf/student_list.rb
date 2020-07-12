# frozen_string_literal: true

module GenronSF
  class StudentList < Resource
    include Enumerable

    attr_reader :year

    def initialize(year:)
      @year = year
      super("#{BASE_URL}#{year}/students/")
    end

    def each(&block)
      to_a.each(&block)
    end

    def to_a
      students
    end

    private

    def students
      @students ||= doc.css('#main .student-list-item a').map do |element|
        id = element['href'].split('/').last
        Student.new(year: year, id: id).tap do |student|
          student.instance_variable_set(:@name, element.at_css('.name').content.strip)
        end
      end
    end
  end
end
