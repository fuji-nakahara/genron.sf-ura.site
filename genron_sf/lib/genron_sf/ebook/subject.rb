# frozen_string_literal: true

require 'gepub'

module GenronSF
  module EBook
    class Subject
      attr_reader :year, :number, :book

      def initialize(year:, number:)
        @year = year
        @number = number
        @book = GEPUB::Book.new
      end

      def generate(path = nil) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
        book.identifier = subject.url
        book.language = 'ja'
        book.title = subject.theme
        book.creator = 'ゲンロン 大森望 SF創作講座'
        book.contributor = subject.lecturers.find { |lecturer| lecturer.roles.include?('課題提示') }

        File.open(TemplateUtil::CSS_FILE_PATH) do |file|
          book.add_item(File.basename(file.path), content: file)
        end

        book.ordered do
          subject.entries.each do |work|
            book.add_item(
              "#{work.student.id}-title.xhtml",
              content: StringIO.new(TemplateUtil.title_xhtml(work.student.name)),
              toc_text: work.student.name,
            )
            book.add_item(
              "#{work.student.id}-work.xhtml",
              content: StringIO.new(TemplateUtil.work_xhtml(work)),
            )
          end
        end

        book.generate_epub(path || "SF創作講座#{subject.year}-#{subject.number.to_s.rjust(2, '0')}.epub")
      end

      private

      def subject
        @subject ||= GenronSF::Subject.new(year: year, number: number)
      end
    end
  end
end
