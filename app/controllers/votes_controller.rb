# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :require_current_user

  def create
    work = Work.find(params[:work_id])
    vote = work.votes.build(user: current_user)

    if vote.save
      render json: work.voters.as_json
    else
      render status: :bad_request, json: { errors: vote.errors.full_messages }
    end
  end

  def destroy
    work = Work.find(params[:work_id])
    vote = work.votes.find_by!(user_id: current_user.id)
    vote.destroy!
    render json: work.voters.as_json
  end
end
