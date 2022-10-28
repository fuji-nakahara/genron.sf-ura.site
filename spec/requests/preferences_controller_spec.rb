# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'PreferencesController:' do
  describe 'PATCH /preference' do
    let(:user) { create(:user) }
    let(:params) { { works_order: } }
    let(:works_order) { 'genron_sf' }

    before do
      log_in user
    end

    it "updates current_user's preference and redirects to /preference" do
      patch preference_path, params: params

      expect(user.reload.preference['works_order']).to eq 'genron_sf'
      expect(response).to have_http_status :no_content
    end

    context 'with invalid params' do
      let(:works_order) { 'INVALID' }

      it 'renders error' do
        patch preference_path, params: params

        expect(user.reload.preference['works_order']).not_to eq 'genron_sf'
        expect(response).to have_http_status :bad_request
      end
    end
  end
end
