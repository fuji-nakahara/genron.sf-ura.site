# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DraftsController, type: :request do
  describe 'GET /drafts/new' do
    before do
      log_in create(:user)
    end

    it 'returns http OK' do
      get new_draft_path

      expect(response).to have_http_status :ok
    end
  end
end
