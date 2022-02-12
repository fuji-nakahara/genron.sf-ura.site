# frozen_string_literal: true

create_table :student_twitter_candidates, force: :cascade do |t|
  t.string :genron_sf_id, null: false
  t.string :twitter_screen_name, null: false

  t.timestamps precision: 6

  t.index :genron_sf_id, unique: true
  t.index :twitter_screen_name, unique: true
end
