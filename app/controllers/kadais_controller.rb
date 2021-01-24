# frozen_string_literal: true

class KadaisController < ApplicationController
  def show
    @kadai = Kadai.find(params[:id])

    order = current_user&.preference_object&.works_order || 'default'
    @jissakus = @kadai.jissakus.includes(:prize, :voters, student: :user).__send__("#{order}_order")
    @kougais = @kadai.kougais.includes(:voters, student: :user).__send__("#{order}_order")
  end
end
