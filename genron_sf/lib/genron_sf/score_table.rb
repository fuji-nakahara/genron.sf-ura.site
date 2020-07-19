# frozen_string_literal: true

module GenronSF
  class ScoreTable < Resource
    include Enumerable

    class << self
      def build_url(year:)
        "#{Resource::BASE_URL}#{year}/scores/"
      end

      def get(year:)
        new(year: year).tap(&:doc)
      end
    end

    attr_reader :year

    def initialize(year:)
      @year = year.to_i
      super(self.class.build_url(year: @year))
    end

    def each(&block)
      student_name_to_scores.each(&block)
    end

    def to_h
      student_name_to_scores
    end

    private

    def student_name_to_scores
      doc.css('#table-scores tbody tr').map do |tr|
        tds = tr.css('td')
        name = tds.first.content
        scores = tds[2..].map { |td| td.content[/\d+/]&.to_i }.compact
        [name, scores]
      end.to_h
    end
  end
end
