# frozen_string_literal: true

class DraftsController < ApplicationController
  def new
    @draft = Draft.new
  end
end
