# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :require_current_user

  def create
    work = Work.find(params[:work_id])
    vote = work.votes.build(user: current_user)

    if vote.save
      head :created
    else
      render status: :bad_request, json: { errors: vote.errors.full_messages }
    end
  end

  def destroy
    vote = Vote.find_by!(work_id: params[:work_id], user_id: current_user.id)
    vote.destroy!
    head :no_content
  end
end
