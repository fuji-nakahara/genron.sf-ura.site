# frozen_string_literal: true

require 'net/http'

require_relative 'error'
require_relative 'score_table'
require_relative 'student'
require_relative 'subject'
require_relative 'resource'

module GenronSF
  class Term
    class << self
      def latest
        uri = URI.parse(Resource::BASE_URL)
        response = Net::HTTP.get_response(uri)
        case response
        when Net::HTTPRedirection
          year = response['location'].split('/').last
          new(year: year)
        else
          raise GenronSF::HTTPError, "Unexpected response: #{response.code} #{response.message}"
        end
      end
    end

    attr_reader :year

    def initialize(year:)
      @year = year.to_i
    end

    def subjects
      @subjects ||= Subject.list(year: year)
    end

    def students
      @students ||= Student.list(year: year)
    end

    def score_table
      @score_table ||= ScoreTable.get(year: year)
    end
  end
end
