# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Vote button', type: :system do
  before do
    driven_by :selenium_chrome_headless
  end

  it 'enables to vote for a work' do
    kadai = create(:kadai)
    kougai = create(:kougai, kadai:)

    log_in create(:user), from: term_kadai_path(kadai.year, kadai)
    click_button '投票する'

    expect(page).to have_content '1'
    expect(kougai.reload.votes_count).to eq 1
  end
end
