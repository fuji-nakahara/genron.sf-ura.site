# frozen_string_literal: true

require_relative 'resource'
require_relative 'student_list'
require_relative 'subject'
require_relative 'work'

module GenronSF
  class Student < Resource
    TWITTER_SCREEN_NAME_REGEXP = %r{
      (?:
        https?://twitter\.com/
        |(?:^|\W)@
      )
      (?<screen_name>\w{1,15})
    }x.freeze

    class << self
      def build_url(year:, id:)
        "#{Resource::BASE_URL}#{year}/students/#{id}/"
      end

      def list(year:)
        StudentList.new(year: year).tap(&:doc)
      end

      def get(year:, id:)
        new(url: build_url(year: year, id: id)).tap(&:doc)
      end
    end

    def initialize(url:, name: nil)
      @name = name
      super(url)
    end

    def year
      url.split('/')[-3].to_i
    end

    def id
      url.split('/').last
    end

    def name
      @name ||= main.at_css('header h1').content.strip
    end

    def profile
      profile = main.at_css('header p').content.strip
      if profile == 'プロフィールが設定されていません。'
        nil
      else
        profile
      end
    end

    def twitter_screen_name
      profile[TWITTER_SCREEN_NAME_REGEXP, :screen_name] if profile
    end

    def works
      @works ||= main.css('.theme-header').map do |header_element|
        work_url = header_element.at_css('.right > a')['href']
        subject = Subject.new(year: year, header_element: header_element)
        Work.new(work_url, subject: subject, student: self)
      end
    end
  end
end
