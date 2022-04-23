# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    include AdminRequired

    def index
      @users = User.includes(:student).order(id: :desc)
    end
  end
end
