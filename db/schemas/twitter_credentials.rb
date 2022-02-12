# frozen_string_literal: true

create_table :twitter_credentials, force: :cascade do |t|
  t.references :user, null: false, index: { unique: true }, foreign_key: true

  t.string :token, null: false
  t.string :secret, null: false

  t.timestamps precision: 6
end
