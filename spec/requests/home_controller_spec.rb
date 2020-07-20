# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'HomeController:', type: :request do
  describe 'GET /' do
    before do
      create(:kadai)
    end

    it 'responds OK' do
      get root_path

      expect(response).to have_http_status :ok
    end
  end
end
