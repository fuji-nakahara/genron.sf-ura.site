# frozen_string_literal: true

class EbooksController < ApplicationController
  before_action :require_current_user
  before_action :require_genron_sf_student

  def index
    @ebook_form = EBookForm.new(student: current_user.student, accept_generating_ebook: true)
  end

  def create
    @ebook_form = EBookForm.new(ebook_params.merge(student: current_user.student))

    if @ebook_form.valid?
      EBookGenerateJob.perform_later(
        year: @ebook_form.year,
        genron_sf_student_id: current_user.student.genron_sf_id,
        email: @ebook_form.email,
      )
      redirect_to ebooks_path, notice: '電子書籍を作成しだいメールを送信します。しばらくお待ちください。'
    else
      render :index
    end
  end

  private

  def require_genron_sf_student
    redirect_to root_path, alert: '正規受講生ではありません' unless current_user.student.genron_sf_id
  end

  def ebook_params
    params.require(:ebook_form).permit(:year, :email, :accept_generating_ebook)
  end
end
