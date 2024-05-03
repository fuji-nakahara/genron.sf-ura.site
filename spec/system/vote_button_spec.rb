# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Vote button' do
  before do
    options = ENV['SELENIUM_REMOTE'] ? { browser: :remote } : {}
    driven_by :selenium, using: :headless_chrome, options:
  end

  it 'enables to vote for a work' do
    kadai = create(:kadai)
    kougai = create(:kougai, kadai:)

    log_in create(:user), from: term_kadai_path(kadai.year, kadai)
    click_on '投票する'

    expect(page).to have_content '1'
    expect(kougai.reload.votes_count).to eq 1
  end
end
