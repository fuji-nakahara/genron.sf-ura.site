# frozen_string_literal: true

class KadaisController < ApplicationController
  before_action :redirect_by_id, only: :show

  def index
    @term = Term.find(params[:term_year])
  end

  def show
    @kadai = Kadai.find_by!(year: params[:term_year], round: params[:round])

    order = current_user&.preference_object&.works_order || 'default'
    @jissakus = @kadai.jissakus.includes(:prize, :voters, :student).__send__("#{order}_order")
    @kougais = @kadai.kougais.includes(:voters, :student).__send__("#{order}_order")
  end

  private

  def redirect_by_id
    return if params[:id].nil?

    kadai = Kadai.find(params[:id])
    redirect_to term_kadai_path(*kadai.year_round), status: :moved_permanently
  end
end
