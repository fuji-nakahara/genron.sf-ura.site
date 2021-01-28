# frozen_string_literal: true

class HomeController < ApplicationController
  def show
    @kadais = Kadai.newest3
    @votes = Vote.includes(:user, work: :student).reverse_order.limit(10)
    @students = Student.joins(works: :kadai)
                       .merge(Kadai.where(year: @kadais.last.year))
                       .with_votes_sum
                       .order(votes_sum: :desc, genron_sf_id: :asc)
  end
end
