# frozen_string_literal: true

class KadaisController < ApplicationController
  before_action :redirect_by_id, only: :show

  def index
    @term = Term.find(params[:term_year])

    respond_to do |format|
      format.html

      format.json do
        render json: @term.kadais.reverse_order.as_json
      end
    end
  end

  def show
    @kadai = Kadai.find_by!(year: params[:term_year], round: params[:round])

    respond_to do |format|
      format.html do
        order = current_user&.preference_object&.works_order || 'default'
        @jissakus = @kadai.jissakus.includes(:prize, :voters, :student).__send__("#{order}_order")
        @kougais = @kadai.kougais.includes(:voters, :student).__send__("#{order}_order")
      end

      format.json do
        render json: @kadai.as_json.merge(
          jissakus: @kadai.jissakus.includes(:student, :voters).order(:id).as_json(include: %i[student voters]),
          kougais: @kadai.kougais.includes(:student, :voters).order(:id).as_json(include: %i[student voters]),
        )
      end
    end
  end

  private

  def redirect_by_id
    return if params[:id].nil?

    kadai = Kadai.find(params[:id])
    redirect_to term_kadai_path(kadai.year, kadai), status: :moved_permanently
  end
end
