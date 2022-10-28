# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MergeStudentsJob do
  describe '#perform' do
    let(:source_user) { create(:user, student: source_student) }
    let(:source_student) { create(:student, genron_sf_id: nil, description: '自己紹介') }
    let(:target_student) { create(:student) }

    before do
      create_pair(:kougai, student: source_user.student)
      create_pair(:jissaku, student: source_user.student)
      create(:vote, user: source_user, work: create(:kougai, student: target_student))
      create(:vote, user: source_user) # Not target
    end

    it 'updates student_id columns from source to target and destroys source' do
      expect do
        described_class.perform_now(
          twitter_screen_name: source_user.twitter_screen_name,
          genron_sf_id: target_student.genron_sf_id,
        )
      end.to change {
        target_student.kougais.count
      }.by(2).and change {
        target_student.jissakus.count
      }.by(2).and change {
        source_user.votes.count
      }.by(-1)

      expect(target_student.reload.description).to eq '自己紹介'
      expect(source_user.reload.student).to eq target_student
      expect { source_student.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
