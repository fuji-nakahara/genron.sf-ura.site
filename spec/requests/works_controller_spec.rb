# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'LinksController:', type: :request do
  describe 'DELETE /works/:id' do
    let(:user) { create(:user) }
    let(:kougai) { create(:kougai, student: user.student, genron_sf_id: nil) }

    before do
      log_in user
    end

    it 'destroys the work and redirects to /kadais/:id' do
      delete work_path(kougai)

      expect(response).to redirect_to kougai.kadai
      expect { kougai.reload }.to raise_error ActiveRecord::RecordNotFound
    end

    context 'when the logged-in user is not the author of the work' do
      let(:another_user) { create(:user) }

      before do
        log_in another_user
      end

      it 'redirects to /kadais/:id' do
        delete work_path(kougai)

        expect(response).to redirect_to kougai.kadai
        expect { kougai.reload }.not_to raise_error
      end
    end

    context 'when kougai has genron_sf_id' do
      let(:kougai) { create(:kougai, student: user.student) }

      it 'redirects to /kadais/:id' do
        delete work_path(kougai)

        expect(response).to redirect_to kougai.kadai
        expect { kougai.reload }.not_to raise_error
      end
    end
  end
end
