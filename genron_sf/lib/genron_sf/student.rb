# frozen_string_literal: true

module GenronSF
  class Student < Resource
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
      profile[%r{https?://twitter\.com/(\w{1,15})}, 1] || profile[/\W@(\w{1,15})/, 1] if profile
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
