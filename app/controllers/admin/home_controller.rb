# frozen_string_literal: true

module Admin
  class HomeController < ApplicationController
    include AdminRequired

    def show
      @genron_sf_student_ids = Student.left_joins(:user).where(users: { id: nil }).pluck(:genron_sf_id)
      @twitter_screen_names = User.joins(:student).merge(Student.where(genron_sf_id: nil)).pluck(:twitter_screen_name)
      @student_merge_candidates = StudentMergeCandidate.includes(:student, :user).order(id: :desc)
      @links = Link.includes(:kadai, :user).order(id: :desc).limit(10)
    end
  end
end
