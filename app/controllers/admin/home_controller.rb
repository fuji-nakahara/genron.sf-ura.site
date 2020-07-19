# frozen_string_literal: true

module Admin
  class HomeController < ApplicationController
    include AdminRequired

    def show
      @users = User.all.reverse_order
      @links = Link.all.reverse_order.limit(10)
      @genron_sf_student_ids = Student.left_joins(:user).where(users: { id: nil }).pluck(:genron_sf_id)
      @twitter_screen_names = User.joins(:student).merge(Student.where(genron_sf_id: nil)).pluck(:twitter_screen_name)
    end
  end
end
