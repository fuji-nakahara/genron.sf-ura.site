# frozen_string_literal: true

create_table :twitter2_credentials, force: :cascade do |t|
  t.references :user, null: false, index: { unique: true }, foreign_key: true

  t.string :refresh_token
  t.string :token, null: false
  t.datetime :expires_at, null: false

  t.timestamps

  t.index :updated_at
end
