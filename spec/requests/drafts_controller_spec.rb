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

  describe 'POST /drafts' do
    let(:params) do
      {
        draft: {
          kind: 'kougai',
          title: 'Identity Disconnect',
          url: 'https://github.com/fuji-nakahara/genron-sf-2022/pull/1/files',
          comment:,
        },
      }
    end
    let(:comment) { 'コメントは GitHub のレビューコメントでお願いします' }

    before do
      log_in create(:user)
    end

    it 'creates a draft, enqueues a job and redirects to /' do
      expect { post drafts_path, params: }.to change(Draft, :count).by(1)

      expect(TweetDraftSubmittedJob).to have_been_enqueued
      expect(response).to redirect_to root_path
    end

    context 'with invalid params' do
      let(:comment) { 'a' * 141 }

      it 'renders error' do
        expect { post drafts_path, params: }.not_to change(Draft, :count)

        expect(TweetDraftSubmittedJob).not_to have_been_enqueued
        expect(response).to have_http_status :unprocessable_entity
      end
    end
  end
end
