# frozen_string_literal: true

create_table :links, force: :cascade do |t|
  t.references :kadai, null: false, foreign_key: true
  t.references :user, foreign_key: true

  t.string :url, null: false
  t.string :title, null: false

  t.timestamps precision: 6
end
