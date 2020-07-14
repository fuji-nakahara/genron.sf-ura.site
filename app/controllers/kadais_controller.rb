# frozen_string_literal: true

class KadaisController < ApplicationController
  def show
    @kadai = Kadai.find(params[:id])
  end
end
