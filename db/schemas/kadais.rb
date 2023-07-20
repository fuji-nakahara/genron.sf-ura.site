# frozen_string_literal: true

create_table :kadais, force: :cascade do |t|
  t.integer :year, null: false, limit: 2
  t.integer :round, null: false, limit: 2
  t.string :title, null: false
  t.string :author
  t.date :kougai_deadline
  t.date :jissaku_deadline
  t.bigint :tweet_id

  t.integer :kougais_count, null: false, default: 0, limit: 2
  t.integer :jissakus_count, null: false, default: 0, limit: 2

  t.timestamps

  t.index %i[year round], unique: true
  t.index :kougai_deadline
  t.index :jissaku_deadline
  t.foreign_key :terms, primary_key: :year, column: :year
end
