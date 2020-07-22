# frozen_string_literal: true

require_relative '../genron_sf'

require_relative 'ebook/student_generator'
require_relative 'ebook/subject_generator'

module GenronSF
  module EBook
    class << self
      def generate_student(year:, id:, path: nil)
        student = GenronSF::Student.get(year: year, id: id)
        generator = GenronSF::EBook::StudentGenerator.new(student)
        generator.generate(path)
      end

      def generate_subject(year:, number:, path: nil)
        subject = GenronSF::Subject.get(year: year, number: number)
        generator = GenronSF::EBook::SubjectGenerator.new(subject)
        generator.generate(path)
      end
    end
  end
end
