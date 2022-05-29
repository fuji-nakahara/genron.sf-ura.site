# frozen_string_literal: true

class DraftsController < ApplicationController
  before_action :require_current_user, only: %i[new create]

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

  private

  def draft_params
    params.require(:draft).permit(:title, :url, :comment, :kind)
  end
end
