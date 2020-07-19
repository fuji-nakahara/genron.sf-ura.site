# frozen_string_literal: true

create_table :twitter_credentials, force: :cascade do |t|
  t.bigint :user_id, null: false
  t.string :token, null: false
  t.string :secret, null: false

  t.timestamps

  t.index :user_id, unique: true
end
add_foreign_key :twitter_credentials, :users
