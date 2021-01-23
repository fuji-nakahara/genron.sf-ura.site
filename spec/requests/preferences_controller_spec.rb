# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PreferencesController:', type: :request do
  describe 'GET /preference' do
    let(:user) { create(:user) }

    before do
      log_in user
    end

    it 'responds OK' do
      get profile_path

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /preference' do
    let(:user) { create(:user) }
    let(:params) do
      {
        user_preference: {
          works_order: works_order,
        },
      }
    end
    let(:works_order) { 'genron_sf' }

    before do
      log_in user
    end

    it "updates current_user's preference and redirects to /preference" do
      patch preference_path, params: params

      expect(user.reload.preference['works_order']).to eq 'genron_sf'
      expect(response).to redirect_to preference_path
    end

    context 'with invalid params' do
      let(:works_order) { 'INVALID' }

      it 'renders error' do
        patch preference_path, params: params

        expect(user.reload.preference['works_order']).not_to eq 'genron_sf'
        expect(response).to have_http_status :ok
      end
    end
  end
end
