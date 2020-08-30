# frozen_string_literal: true

create_table :prizes, force: :cascade do |t|
  t.bigint :jissaku_id, null: false
  t.string :title, null: false
  t.integer :position, null: false, default: 0, limit: 2

  t.timestamps

  t.index :jissaku_id, unique: true
end
add_foreign_key :prizes, :works, column: :jissaku_id
