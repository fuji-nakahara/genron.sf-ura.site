# frozen_string_literal: true

module GenronSF
  class Student < Resource
    class << self
      def list(year:)
        StudentList.new(year: year).tap(&:doc)
      end

      def get(year:, id:)
        new(year: year, id: id).tap(&:doc)
      end
    end

    attr_reader :year, :id

    def initialize(year:, id:)
      @year = year
      @id = id
      super("#{BASE_URL}#{year}/students/#{id}/")
    end

    def name
      @name ||= doc.at_css('#main header h1').content.strip
    end

    def profile
      profile = doc.at_css('#main header p').content.strip
      if profile == 'プロフィールが設定されていません。'
        nil
      else
        profile
      end
    end
  end
end
