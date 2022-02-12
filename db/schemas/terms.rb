# frozen_string_literal: true

create_table :terms, primary_key: :year, id: { type: :serial }, force: :cascade do |t| # rubocop:disable Style/SymbolProc
  t.timestamps precision: 6
end
