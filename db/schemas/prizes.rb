# frozen_string_literal: true

create_table :prizes, force: :cascade do |t|
  t.references :jissaku, null: false, index: { unique: true }, foreign_key: { to_table: :works, column: :jissaku_id }

  t.string :title, null: false
  t.integer :position, null: false, default: 0, limit: 2

  t.timestamps precision: 6
end
