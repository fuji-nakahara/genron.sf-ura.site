# frozen_string_literal: true

create_table :votes, force: :cascade do |t|
  t.bigint :user_id, null: false
  t.bigint :work_id, null: false

  t.timestamps

  t.index %i[user_id work_id], unique: true
  t.index :work_id
end
add_foreign_key :votes, :users
add_foreign_key :votes, :works
