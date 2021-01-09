# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'SessionsController:', type: :request do
  describe 'GET /auth/twitter/callback' do
    context 'with a new user' do
      before do
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
          {
            uid: '123456789012345678',
            info: {
              nickname: 'fuji_nakahara',
              name: 'フジ・ナカハラ',
              image: 'http://pbs.twimg.com/profile_images/988828274468962304/PkwwByKg_normal.jpg',
              urls: {
                'Twitter': 'https://twitter.com/fuji_nakahara',
              },
            },
            credentials: {
              token: 'token',
              secret: 'secret',
            },
          },
        )
      end

      it 'creates a user and sets session[:user_id]' do
        expect { get auth_twitter_callback_path }
          .to change(User, :count).by(1).and change(Student, :count).by(1)

        expect(session[:user_id]).not_to be_nil
        expect(response).to redirect_to root_path
      end
    end

    context 'with an existing user' do
      let(:user) { create(:user) }

      before do
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new(
          {
            uid: user.twitter_id,
            info: {
              nickname: 'fuji_nakahara',
              name: 'フジ・ナカハラ',
              image: 'http://pbs.twimg.com/profile_images/988828274468962304/PkwwByKg_normal.jpg',
              urls: {
                'Twitter': 'https://twitter.com/fuji_nakahara',
              },
            },
            credentials: {
              token: 'token',
              secret: 'secret',
            },
          },
        )
      end

      it 'sets session[:user_id]' do
        expect { get auth_twitter_callback_path }
          .not_to change(User, :count)

        expect(session[:user_id]).to eq user.id
        expect(response).to redirect_to root_path
      end
    end

    context 'with invalid credentials' do
      before do
        OmniAuth.config.mock_auth[:twitter] = :invalid_credentials
      end

      it 'redirects to /auth/failure' do
        expect { get auth_twitter_callback_path }
          .not_to change(User, :count)

        expect(session[:user_id]).to be_nil
        expect(response).to have_http_status :redirect
      end
    end
  end

  describe 'GET /auth/failure' do
    it 'redirects to /' do
      get auth_failure_path

      expect(response).to redirect_to root_path
    end
  end

  describe 'POST /logout' do
    let(:user) { create(:user) }

    before do
      log_in user
    end

    it 'resets session' do
      post logout_path

      expect(session[:user_id]).to be_nil
      expect(response).to redirect_to root_path
    end
  end
end
