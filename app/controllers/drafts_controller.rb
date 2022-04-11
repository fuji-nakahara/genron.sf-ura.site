# frozen_string_literal: true

class DraftsController < ApplicationController
  before_action :require_current_user

  def new
    @draft = Draft.new
  end

  def create
    @draft = Draft.new(draft_params.merge(student: current_user.student))

    if @draft.save
      TweetDraftSubmittedJob.perform_later(@draft)
      redirect_to root_path, notice: '投稿しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @draft = current_user.student.drafts.find(params[:id])
    GenronSFFun::TwitterClient.instance.destroy_tweet(@draft.tweet_url) if @draft.tweet_url.present?
    @draft.destroy!
    redirect_to root_path, notice: '削除しました'
  end

  private

  def draft_params
    params.require(:draft).permit(:title, :url, :comment, :kind)
  end
end
