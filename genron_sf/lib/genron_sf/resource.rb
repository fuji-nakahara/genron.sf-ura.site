# frozen_string_literal: true

require 'open-uri'
require 'nokogiri'

require_relative 'error'

module GenronSF
  class Resource
    BASE_URL = 'https://school.genron.co.jp/works/sf/'

    attr_reader :url

    def initialize(url)
      @url = url
    end

    def doc
      @doc ||= fetch_and_parse!
    end

    private

    def main
      doc.at_css('#main')
    end

    def fetch_and_parse!
      GenronSF.logger.info "Fetching #{url}"
      io = URI.open(url, redirect: false)
      Nokogiri::HTML.parse(io)
    rescue OpenURI::HTTPError => e
      raise HTTPError, "Failed to fetch #{url}: #{e.message}"
    end
  end
end
