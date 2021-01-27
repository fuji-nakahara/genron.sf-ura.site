# frozen_string_literal: true

class MergeStudentsJob < ApplicationJob
  def perform(twitter_screen_name:, genron_sf_id:)
    source = Student.joins(:user).merge(User.where(twitter_screen_name: twitter_screen_name))
                    .where(genron_sf_id: nil).take!
    target = Student.left_joins(:user).where(users: { id: nil })
                    .where(genron_sf_id: genron_sf_id).take!
    user = source.user

    Student.transaction do
      Vote.joins(:work).merge(Work.where(student_id: target.id)).where(user_id: user.id).delete_all
      Work.where(student_id: source.id).update_all(student_id: target.id) # rubocop:disable Rails/SkipsModelValidations
      target.update!(description: source.description)
      user.update!(student: target)
      source.reload.destroy!
    end
  end
end
