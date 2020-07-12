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
      @year = year
      @number = number || (header_element.nil? ? nil : header_element.at_css('.number').content[/\d+/].to_i)
      @header_element = header_element
      super(self.class.build_url(year: year, number: @number))
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

    def without_summary?
      summary_deadline.nil?
    end

    def summaries(force: false)
      return [] if without_summary? && !force

      @summaries ||= main.css('.written a').map do |element|
        url = element['href']
        Work.new(url, subject: self) if !url.nil? && !url.empty?
      end.compact
    end

    def works
      @works ||= main.css(without_summary? ? '.written a' : '.has-work a').map do |element|
        url = element['href']
        Work.new(url, subject: self) if !url.nil? && !url.empty?
      end.compact
    end

    def scores
      @scores ||= main.css('.has-score').map do |element|
        url = element.at_css('a')['href']
        score = element.at_css('.score')&.content&.to_i
        Score.new(work: Work.new(url, subject: self), value: score) if !url.nil? && !url.empty?
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
