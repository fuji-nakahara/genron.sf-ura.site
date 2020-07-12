# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

module GenronSF
  class Resource
    BASE_URL = 'https://school.genron.co.jp/works/sf/'

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def doc
      @doc ||= Nokogiri::HTML(URI.open(url))
    end
  end
end
