# frozen_string_literal: true

class TermsController < ApplicationController
  def index
    @kadais = Kadai.newest3
    @votes = Vote.includes(:user, work: %i[kadai student]).reverse_order.limit(10)
    @students = Student.joins(works: :kadai)
                       .merge(Kadai.where(year: @kadais.last.year))
                       .with_votes_sum
                       .order(votes_sum: :desc, genron_sf_id: :asc)
  end
end
