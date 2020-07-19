# frozen_string_literal: true

class WorksController < ApplicationController
  before_action :require_current_user
  before_action :require_author

  def destroy
    @work.destroy!
    redirect_to @work.kadai, notice: '削除しました'
  end

  private

  def require_author
    @work = Work.find(params[:id])
    redirect_to @work.kadai, alert: '権限がありません' if current_user.student_id != @work.student_id
  end
end
