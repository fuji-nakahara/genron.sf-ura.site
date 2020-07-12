# frozen_string_literal: true

module GenronSF
  class Lecturer
    attr_reader :name, :roles, :note

    def initialize(name:, roles:, note:)
      @name = name
      @roles = roles
      @note = note
    end
  end
end
