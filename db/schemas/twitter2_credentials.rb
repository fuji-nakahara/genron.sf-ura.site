# frozen_string_literal: true

create_table :twitter2_credentials, force: :cascade do |t|
  t.references :user, null: false, index: { unique: true }, foreign_key: true

  t.string :refresh_token # TODO: Make not null after all refresh_token columns are filled.
  t.string :token, null: false
  t.datetime :expires_at, null: false

  t.timestamps
end
