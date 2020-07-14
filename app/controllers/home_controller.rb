# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @kadais = Kadai.newest_order.limit(3)
  end

  def hello_sentry

  end
end
