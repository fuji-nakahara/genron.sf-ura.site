# frozen_string_literal: true

require 'rails_helper'

RSpec.describe MergeStudentsJob, type: :job do
  describe '#perform' do
    let(:source) { create(:student, :informal) }
    let(:target) { create(:student) }

    before do
      create_pair(:kougai, student: source)
      create_pair(:jissaku, student: source)
    end

    it 'updates student_id columns from source to target and destroys source' do
      user = source.user

      described_class.perform_now(
        twitter_screen_name: source.user.twitter_screen_name,
        genron_sf_id: target.genron_sf_id,
      )

      expect(target.user).to eq user
      expect(target.kougais.size).to eq 2
      expect(target.jissakus.size).to eq 2
      expect { source.reload }.to raise_error ActiveRecord::RecordNotFound
    end
  end
end
