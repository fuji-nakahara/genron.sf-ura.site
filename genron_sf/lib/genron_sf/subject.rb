# frozen_string_literal: true

module GenronSF
  class Subject < Resource
    class << self
      def build_url(year:, number:)
        "#{Resource::BASE_URL}#{year}/subjects/#{number}/"
      end

      def list(year:)
        SubjectList.new(year: year).tap(&:doc)
      end

      def get(year:, number:)
        new(year: year, number: number).tap(&:doc)
      end
    end

    attr_reader :year, :number

    def initialize(year:, number: nil, header_element: nil)
      raise ArgumentError, 'Specify number or header_element' if number.nil? && header_element.nil?

      @year = year.to_i
      @number = if number.nil?
                  header_element.at_css('.number').content[/\d+/].to_i
                else
                  number.to_i
                end
      @header_element = header_element
      super(self.class.build_url(year: year, number: @number))
    end

    def theme
      header_element.at_css('h1').content.strip[/\A「(.*)」\z/, 1]
    end

    def detail
      main.at_css('.entry-content').content.strip
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

    def lecturers
      LecturerList.new(header_element.at_css('.lecturer-name-list'))
    end

    def without_summary?
      summary_deadline.nil? || number == 11
    end

    def summaries
      if without_summary?
        []
      else
        entries
      end
    end

    def works
      if without_summary?
        entries
      else
        main.css('.has-work a').map { |element| entries.find { |entry| entry.url == element['href'] } }.compact
      end
    end

    def entries
      @entries ||= main.css('.written a').map do |element|
        url = element['href']
        student = Student.new(url: url.delete_suffix("#{url.split('/').last}/"), name: element.at_css('.name').content)
        Work.new(url, subject: self, student: student) if !url.nil? && !url.empty?
      end.compact
    end

    def scores
      @scores ||= main.css('.has-score').map do |element|
        work = entries.find { |entry| entry.url == element.at_css('a')['href'] }
        score = element.at_css('.score')&.content&.to_i
        Score.new(work: work, value: score) if !work.nil? && !score.nil?
      end.compact
    end

    private

    def header_element
      @header_element ||= main.at_css('.theme-header')
    end

    def parse_date(date_str)
      Date.strptime(date_str, '%Y年%m月%d日')
    rescue ArgumentError
      nil
    end
  end
end
