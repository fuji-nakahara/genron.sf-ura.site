# frozen_string_literal: true

create_table :links, force: :cascade do |t|
  t.bigint :kadai_id, null: false
  t.bigint :user_id
  t.string :url, null: false
  t.string :title, null: false

  t.timestamps

  t.index %i[kadai_id created_at]
  t.index :user_id
end
add_foreign_key :links, :kadais
add_foreign_key :links, :users
