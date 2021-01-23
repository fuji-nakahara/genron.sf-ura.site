# frozen_string_literal: true

create_table :kadais, force: :cascade do |t|
  t.integer :year, null: false, limit: 2
  t.integer :number, null: false, limit: 2
  t.string :title, null: false
  t.string :author
  t.date :kougai_deadline
  t.date :jissaku_deadline
  t.string :tweet_url
  t.integer :works_count, null: false, default: 0, limit: 2

  t.timestamps

  t.index %i[year number], unique: true
  t.index :kougai_deadline
  t.index :jissaku_deadline
end
