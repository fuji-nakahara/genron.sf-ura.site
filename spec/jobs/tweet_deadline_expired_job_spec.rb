# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TweetDeadlineExpiredJob, type: :job do
  describe '#perform' do
    let(:deadline) { 1.day.ago.to_date }
    let(:twitter_client) { instance_spy(GenronSFFun::TwitterClient) }

    before do
      create(:kadai, number: 2, kougai_deadline: deadline)
      allow(GenronSFFun::TwitterClient).to receive(:instance).and_return(twitter_client)
    end

    it 'tweets deadline expired kadai' do
      described_class.perform_now(deadline)

      expect(twitter_client).to have_received(:update).with(/\A第2回梗概締切です！/)
    end

    context 'with one more expired kadai' do
      before do
        create(:kadai, number: 1, jissaku_deadline: deadline)
      end

      it 'tweets all deadline expired kadais' do
        described_class.perform_now(deadline)

        expect(twitter_client).to have_received(:update).with(/\A第1回実作、第2回梗概締切です！/)
      end
    end
  end
end
