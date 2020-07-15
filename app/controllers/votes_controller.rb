# frozen_string_literal: true

class VotesController < ApplicationController
  before_action :require_current_user

  def create
    work = Work.find(params[:work_id])
    vote = work.votes.build(user: current_user)

    result = vote.save
    flash.alert = vote.errors.full_messages.join(' / ') unless result
    redirect_to work.kadai
  end

  def destroy
    vote = Vote.find(params[:id])
    vote.destroy!
    redirect_to vote.work.kadai
  end
end
