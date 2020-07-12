# frozen_string_literal: true

module GenronSF
  class Score
    attr_reader :work, :value

    def initialize(work:, value:)
      @work = work
      @value = value
    end
  end
end
