# frozen_string_literal: true

class MergeStudentsJob < ApplicationJob
  def perform(source_id:, target_id:)
    source = Student.joins(:user).where(genron_sf_id: nil).find(source_id)
    target = Student.left_joins(:user).where(users: { id: nil }).where.not(genron_sf_id: nil).find(target_id)
    user = source.user

    Student.transaction do
      Work.where(student_id: source.id).update_all(student_id: target.id) # rubocop:disable Rails/SkipsModelValidations
      user.update!(student: target)
      source.reload.destroy!
    end
  end
end
