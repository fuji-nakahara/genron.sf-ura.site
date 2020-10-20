# frozen_string_literal: true

create_table :elections, force: :cascade do |t|
  t.bigint :kougai_id, null: false
  t.string :tweet_url

  t.datetime :created_at, null: false

  t.index :kougai_id, unique: true
end
add_foreign_key :elections, :works, column: :kougai_id
