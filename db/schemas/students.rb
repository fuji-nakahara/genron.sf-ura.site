# frozen_string_literal: true

create_table :students, force: :cascade do |t|
  t.string :genron_sf_id
  t.string :name, null: false
  t.string :url, null: false
  t.string :description

  t.timestamps precision: 6

  t.index :genron_sf_id, unique: true
end
