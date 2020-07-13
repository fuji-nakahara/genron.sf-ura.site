# frozen_string_literal: true

class KadaisController < ApplicationController
  def index
    @kadais = Kadai.newest_order
  end

  def show
    @kadai = Kadai.find(params[:id])
  end
end
