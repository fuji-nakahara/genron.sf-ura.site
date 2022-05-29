# frozen_string_literal: true

create_table :drafts, force: :cascade do |t|
  t.references :kadai, null: false, foreign_key: true
  t.references :student, null: false, foreign_key: true

  t.integer :kind, null: false, limit: 2
  t.string :title, null: false
  t.string :url, null: false
  t.text :comment
  t.string :tweet_url

  t.timestamps
end
