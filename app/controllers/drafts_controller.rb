# frozen_string_literal: true

class DraftsController < ApplicationController
  before_action :require_current_user, only: %i[new create]

  def new
    @draft = Draft.new
  end

  def create
    @draft = Draft.new(
      draft_params.merge( # TODO: 課題と種類をユーザが選択できるようにする
        kadai: Kadai.newest_order.first,
        student: current_user.student,
        kind: :kougai,
      ),
    )

    if @draft.save
      redirect_to root_path, notice: '投稿しました'
    else
      render :new
    end
  end

  private

  def draft_params
    params.require(:draft).permit(:title, :url, :comment)
  end
end
