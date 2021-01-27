# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'ProfilesController:', type: :request do
  describe 'GET /profile' do
    let(:user) { create(:user) }

    before do
      log_in user
    end

    it 'responds OK' do
      get profile_path

      expect(response).to have_http_status :ok
    end
  end

  describe 'POST /profile' do
    let(:user) { create(:user) }
    let(:params) do
      {
        student: {
          name: name,
          url: 'https://example.com/new_profile',
          description: description,
        },
      }
    end
    let(:name) { '新しい名前' }
    let(:description) { '新しい自己紹介' }

    before do
      log_in user
    end

    it "updates current_user's profile and redirects to /profile" do
      patch profile_path, params: params

      expect(user.student.reload.name).to eq '新しい名前'
      expect(user.student.description).to eq '新しい自己紹介'
      expect(response).to redirect_to profile_path
    end

    context 'when name is invalid' do
      let(:name) { '' }

      it 'renders error' do
        patch profile_path, params: params

        expect(user.student.reload.name).not_to eq ''
        expect(response).to have_http_status :ok
      end
    end

    context 'when a Genron SF student tries to update their profile' do
      let(:user) { create(:user, student: create(:student)) }

      it 'updates their description but does not update name' do
        patch profile_path, params: params

        expect(user.student.reload.name).not_to eq '新しい名前'
        expect(user.student.description).to eq '新しい自己紹介'
        expect(response).to redirect_to profile_path
      end
    end
  end
end
