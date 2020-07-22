# frozen_string_literal: true

require 'gepub'

module GenronSF
  module EBook
    class Generator
      attr_reader :book

      def initialize
        @book = GEPUB::Book.new
      end

      def generate(_path = nil)
        raise NotImplementedError
      end
    end
  end
end
