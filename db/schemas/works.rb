# frozen_string_literal: true

create_table :works, force: :cascade do |t|
  t.references :kadai, null: false, index: false, foreign_key: true
  t.references :student, null: false, index: false, foreign_key: true

  t.string :type, null: false
  t.integer :genron_sf_id
  t.string :title, null: false
  t.string :url, null: false
  t.boolean :selected, null: false, default: false
  t.integer :score, null: false, default: 0, limit: 2
  t.string :tweet_url

  t.integer :votes_count, null: false, default: 0, limit: 2

  t.timestamps precision: 6

  t.index %i[kadai_id type]
  t.index %i[student_id type]
  t.index %i[type genron_sf_id], unique: true
end
