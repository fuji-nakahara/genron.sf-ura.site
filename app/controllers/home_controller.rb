# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @kadais = Kadai.newest3
    @votes = Vote.includes(:user, work: :student).reverse_order.limit(6)
  end
end
