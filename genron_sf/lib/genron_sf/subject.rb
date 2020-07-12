# frozen_string_literal: true

module GenronSF
  class Subject < Resource
    class << self
      def list(year:)
        SubjectList.new(year: year).tap(&:doc)
      end

      def get(year:, number:)
        new(year: year, number: number).tap(&:doc)
      end
    end

    attr_reader :year, :number

    def initialize(year:, number:)
      @year = year
      @number = number
      super("#{BASE_URL}#{year}/subjects/#{number}/")
    end

    def theme
      header_element.at_css('h1').content.strip[/\A「(.*)」\z/, 1]
    end

    def lecturers
      LecturerList.new(header_element.at_css('.lecturer-name-list'))
    end

    def summary_deadline
      date_str = header_element.at_css('.date-deadline .date')&.content
      parse_date(date_str.strip) if date_str
    end

    def summary_comment_date
      date_str = header_element.at_css('.date-comment .date')&.content
      parse_date(date_str.strip) if date_str
    end

    def work_deadline
      date_str = header_element.at_css('.date-deadline-work .date')&.content
      parse_date(date_str.strip) if date_str
    end

    def work_comment_date
      date_str = header_element.at_css('.date-comment-work .date')&.content
      parse_date(date_str.strip) if date_str
    end

    private

    def header_element
      @header_element ||= doc.at_css('#main .theme-header')
    end

    def parse_date(date_str)
      Date.strptime(date_str, '%Y年%m月%d日')
    rescue ArgumentError
      nil
    end
  end
end
