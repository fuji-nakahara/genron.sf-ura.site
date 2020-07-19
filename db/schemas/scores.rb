# frozen_string_literal: true

create_table :scores, force: :cascade do |t|
  t.bigint :jissaku_id, null: false
  t.integer :value, null: false, limit: 2

  t.timestamps

  t.index :jissaku_id, unique: true
end
add_foreign_key :scores, :works, column: :jissaku_id
