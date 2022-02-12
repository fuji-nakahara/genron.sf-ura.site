# frozen_string_literal: true

create_table :votes, force: :cascade do |t|
  t.references :user, null: false, index: false, foreign_key: true
  t.references :work, null: false, foreign_key: true

  t.timestamps precision: 6

  t.index %i[user_id work_id], unique: true
end
