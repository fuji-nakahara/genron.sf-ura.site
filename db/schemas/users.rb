# frozen_string_literal: true

create_table :users, force: :cascade do |t|
  t.references :student, null: false, index: { unique: true }, foreign_key: true

  t.bigint :twitter_id, null: false
  t.string :image_url, null: false
  t.string :twitter_screen_name, null: false
  t.jsonb :preference, null: false, default: {}
  t.boolean :admin, null: false, default: false
  t.datetime :last_logged_in_at, null: false

  t.timestamps

  t.index :twitter_id, unique: true
  t.index :twitter_screen_name, unique: true
end
