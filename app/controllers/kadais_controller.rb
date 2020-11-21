# frozen_string_literal: true

class KadaisController < ApplicationController
  def show
    @kadai = Kadai.find(params[:id])

    order = params[:order] == 'genron_sf' ? 'genron_sf' : 'default'
    @jissakus = @kadai.jissakus.includes(:prize, :score, :voters, student: :user).send("#{order}_order")
    @kougais = @kadai.kougais.includes(:voters, student: :user).send("#{order}_order")
  end

  def find
    @kadai = Kadai.find_by!(year: params[:year], number: params[:number])
    redirect_to @kadai, status: :moved_permanently
  end
end
