# frozen_string_literal: true

class TermsController < ApplicationController
  def index
    @kadais = Kadai.newest3
    @votes = Vote.includes(:user, work: %i[kadai student]).reverse_order.limit(10)
  end
end
