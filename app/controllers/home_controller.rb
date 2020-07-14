# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @kadais = Kadai.newest3
  end
end
