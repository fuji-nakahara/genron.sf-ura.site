# frozen_string_literal: true

create_table :works, force: :cascade do |t|
  t.bigint :kadai_id, null: false
  t.bigint :student_id, null: false

  t.string :type, null: false
  t.integer :genron_sf_id
  t.string :title, null: false
  t.string :url, null: false
  t.string :tweet_url
  t.boolean :selected, null: false, default: false
  t.integer :score, null: false, default: 0, limit: 2

  t.integer :votes_count, null: false, default: 0, limit: 2

  t.timestamps

  t.index %i[kadai_id type]
  t.index %i[student_id type]
  t.index %i[type genron_sf_id], unique: true
end
add_foreign_key :works, :kadais
add_foreign_key :works, :students
