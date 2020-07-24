# frozen_string_literal: true

class UserMailer < ApplicationMailer
  default from: '"裏SF創作講座" <fujinakahara2032@gmail.com>'

  def ebook(student:, email:, ebook_path:)
    @student = student
    attachments[File.basename(ebook_path)] = File.read(ebook_path)
    mail subject: '電子書籍を作成しました', to: email
  end
end
