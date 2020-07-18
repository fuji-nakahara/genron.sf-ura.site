# frozen_string_literal: true

require 'erb'

module GenronSF
  module EBook
    module TemplateUtil
      CSS_FILE_PATH = File.expand_path('../../../assets/main.css', __dir__)

      class << self
        def title_xhtml(title)
          ERB.new(title_template).result_with_hash(title: title)
        end

        def work_xhtml(work)
          ERB.new(work_template).result_with_hash(work: work)
        end

        private

        def title_template
          @title_template ||= File.read(File.expand_path('../../../assets/title.xhtml.erb', __dir__))
        end

        def work_template
          @work_template ||= File.read(File.expand_path('../../../assets/work.xhtml.erb', __dir__))
        end
      end
    end
  end
end
