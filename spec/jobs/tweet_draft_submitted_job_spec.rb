# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TweetDraftSubmittedJob, type: :job do
  describe '#perform' do
    let(:draft) do
      create(
        :draft,
        kind: :kougai,
        title: 'Identity Disconnect',
        url: 'https://github.com/fuji-nakahara/genron-sf-2022/pull/1/files',
        comment: 'コメントは GitHub のレビューコメントでお願いします',
        tweet_url: nil,
      )
    end
    let(:twitter_client) { instance_double(GenronSFFun::TwitterClient) }

    before do
      create(:user, student: draft.student, twitter_screen_name: 'fuji_nakahara')
      allow(GenronSFFun::TwitterClient).to receive(:instance).and_return(twitter_client)
      allow(twitter_client).to receive(:update).and_return(
        instance_double(Twitter::Tweet, url: 'https://twitter.com/genron_sf_fun/status/1513501651331686403'),
      )
    end

    it 'tweets and saves tweet_url on the given draft' do
      described_class.perform_now(draft)

      expect(twitter_client).to have_received(:update).with(<<~TWEET)
        【梗概下書き】@fuji_nakahara『Identity Disconnect』
        コメントは GitHub のレビューコメントでお願いします
        #裏SF創作講座
        https://github.com/fuji-nakahara/genron-sf-2022/pull/1/files
      TWEET
      expect(draft.reload.tweet_url).not_to be_nil
    end
  end
end
