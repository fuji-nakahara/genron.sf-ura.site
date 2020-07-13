# frozen_string_literal: true

module GenronSF
  class LecturerList
    include Enumerable

    attr_reader :doc

    def initialize(lecturer_list_element)
      @doc = lecturer_list_element
    end

    def each(&block)
      lecturers.each(&block)
    end

    private

    def lecturers
      @lecturers ||= doc.css('.lecturer-name-list-item').map do |element|
        match = element.at_css('.lecturer-name').content.match(/(?<name>[^（）]+)(?<note_container>（(?<note>.*)）)?/)
        roles = element.at_css('.lecturer-role').content[/(.+?)：/, 1].split(/[、・]/)
        Lecturer.new(name: match[:name].strip, roles: roles, note: match[:note])
      end
    end
  end
end
