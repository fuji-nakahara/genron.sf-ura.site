# frozen_string_literal: true

require_relative 'resource'
require_relative 'student'
require_relative 'subject'

module GenronSF
  class Work < Resource
    class << self
      def build_url(year:, student_id:, id:)
        "#{Resource::BASE_URL}#{year}/students/#{student_id}/#{id}/"
      end

      def get(year:, student_id:, id:)
        new(build_url(year: year, student_id: student_id, id: id)).tap(&:doc)
      end
    end

    def initialize(url, subject: nil, student: nil)
      @subject = subject
      @student = student
      super(url)
    end

    def year
      url.split('/')[-4].to_i
    end

    def id
      url.split('/').last.to_i
    end

    def subject
      @subject ||= Subject.new(year: year, header_element: main.at_css('.theme-header'))
    end

    def student
      @student ||= Student.new(
        url: main.at_css('.student-data a')['href'],
        name: main.at_css('.student-data .name').content.strip,
      )
    end

    def summary_title
      main.at_css('.summary-title')&.content
    end

    def summary
      main.at_css('.summary-content')&.children&.slice(0...-2)
    end

    def summary_character_count
      main.at_css('.summary-content .count-character')&.content&.slice(/文字数：(\d+)/, 1)&.to_i
    end

    def title
      main.at_css('.work-title')&.content
    end

    def body
      main.at_css('.work-content')&.children&.slice(0...-2)
    end

    def character_count
      main.at_css('.work-content .count-character')&.content&.slice(/文字数：(\d+)/, 1)&.to_i
    end

    def appeal
      main.at_css('.appeal-content')&.children&.slice(0...-2)
    end

    def appeal_character_count
      main.at_css('.appeal-content .count-character')&.content&.slice(/文字数：(\d+)/, 1)&.to_i
    end
  end
end
