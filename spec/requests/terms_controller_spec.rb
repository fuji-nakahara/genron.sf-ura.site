# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'TermsController:', type: :request do
  describe 'GET /' do
    before do
      create_list(:kadai, 3)
      create_list(:vote, 10)
    end

    it 'responds OK' do
      get terms_path

      expect(response).to have_http_status :ok
    end
  end
end
