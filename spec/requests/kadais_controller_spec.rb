# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'KadaisController:', type: :request do
  describe 'GET /kadais' do
    before do
      create_list(:kadai, 3)
    end

    it 'responds OK' do
      get kadais_path

      expect(response).to have_http_status :ok
    end
  end

  describe 'GET /kadais/:id' do
    let(:kadai) { create(:kadai) }

    it 'responds OK' do
      get kadai_path(kadai)

      expect(response).to have_http_status :ok
    end
  end
end
