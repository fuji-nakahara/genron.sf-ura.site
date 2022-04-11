require 'rails_helper'

RSpec.describe DraftsController, type: :request do
  describe 'GET /drafts/new' do
    it 'returns http OK' do
      get new_draft_path

      expect(response).to have_http_status :ok
    end
  end
end
