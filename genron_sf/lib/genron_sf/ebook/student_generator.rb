# frozen_string_literal: true

require_relative 'generator'
require_relative 'template_util'

module GenronSF
  module EBook
    class StudentGenerator < Generator
      attr_reader :student

      def initialize(student)
        @student = student
        super()
      end

      def generate(path = nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        book.identifier = student.url
        book.language = 'ja'
        book.title = "#{student.name} SF創作講座 #{student.year} 作品集"
        book.creator = student.name
        book.contributor = 'ゲンロン 大森望 SF創作講座'

        File.open(TemplateUtil::CSS_FILE_PATH) do |file|
          book.add_item(File.basename(file.path), content: file)
        end

        book.ordered do
          student.works.each do |work|
            title = "第#{work.subject.number}回 #{work.subject.theme}"
            book.add_item(
              "#{work.subject.number}-title.xhtml",
              content: StringIO.new(TemplateUtil.title_xhtml(title)),
              toc_text: title,
            )
            book.add_item(
              "#{work.subject.number}-work.xhtml",
              content: StringIO.new(TemplateUtil.work_xhtml(work)),
            )
          end
        end

        book.generate_epub(path || "SF創作講座#{student.year}-#{student.id}.epub")
      end
    end
  end
end
