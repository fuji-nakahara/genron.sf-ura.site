# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'VotesController:', type: :request do
  describe 'POST /works/:work_id/vote' do
    let(:user) { create(:user) }

    let(:kougai) { create(:kougai) }

    before do
      log_in user
    end

    it 'creates a vote and responds OK' do
      expect { post work_vote_path(kougai) }
        .to change { kougai.votes.count }.by(1)

      expect(response).to have_http_status :ok
    end

    context 'when user have already voted for other 3 works' do
      before do
        3.times do # rubocop:disable RSpec/FactoryBot/CreateList
          create(:vote, user:, work: create(:kougai, kadai: kougai.kadai))
        end
      end

      it 'responds BadRequest' do
        expect { post work_vote_path(kougai) }
          .not_to(change { kougai.votes.count })

        expect(response).to have_http_status :bad_request
      end
    end
  end

  describe 'DELETE /works/:work_id/vote' do
    let(:user) { create(:user) }

    let!(:vote) { create(:vote, user:) }

    before do
      log_in user
    end

    it 'destroys the vote and responds OK' do
      expect { delete work_vote_path(vote.work) }
        .to change(Vote, :count).by(-1)

      expect(response).to have_http_status :ok
    end
  end
end
