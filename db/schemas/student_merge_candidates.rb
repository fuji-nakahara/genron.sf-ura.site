# frozen_string_literal: true

create_table :student_merge_candidates, force: :cascade do |t|
  t.belongs_to :student, null: false
  t.belongs_to :user, null: false

  t.datetime :created_at
end
