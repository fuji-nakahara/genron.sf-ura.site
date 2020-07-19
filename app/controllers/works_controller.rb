# frozen_string_literal: true

class WorksController < ApplicationController
  before_action :require_current_user
  before_action :require_author

  def destroy
    if @work.destroy
      flash.notice = '削除しました'
    else
      flash.alert = @work.errors.full_messages.join(' / ')
    end
    redirect_to @work.kadai
  end

  private

  def require_author
    @work = Work.find(params[:id])
    redirect_to @work.kadai, alert: '権限がありません' if current_user.student_id != @work.student_id
  end
end
