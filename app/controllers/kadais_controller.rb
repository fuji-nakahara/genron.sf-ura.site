# frozen_string_literal: true

class KadaisController < ApplicationController
  before_action :redirect_by_id, only: :show

  def index
    @term = Term.find(params[:term_year])

    respond_to do |format|
      format.html

      format.json do
        render json: @term.kadais.as_json(
          only: %i[year round title author kougai_deadline jissaku_deadline kougais_count jissakus_count],
          methods: :genron_sf_url,
        )
      end
    end
  end

  def show
    @kadai = Kadai.find_by!(year: params[:term_year], round: params[:round])

    order = current_user&.preference_object&.works_order || 'default'
    @jissakus = @kadai.jissakus.includes(:prize, :voters, :student).__send__("#{order}_order")
    @kougais = @kadai.kougais.includes(:voters, :student).__send__("#{order}_order")

    respond_to do |format|
      format.html

      format.json do
        work_options = {
          only: %i[genron_sf_id title url selected score],
          include: {
            student: { only: %i[id genron_sf_id name] },
            voters: { only: :twitter_screen_name },
          },
        }
        render json: @kadai.as_json(
          only: %i[year round title author kougai_deadline jissaku_deadline],
          methods: :genron_sf_url,
        ).merge(
          jissakus: @jissakus.as_json(work_options),
          kougais: @kougais.as_json(work_options),
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
