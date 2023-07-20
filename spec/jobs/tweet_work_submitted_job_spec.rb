# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TweetWorkSubmittedJob do
  describe '#perform' do
    let(:work) do
      create(
        :kougai,
        kadai: create(:kadai, term: create(:term, year: 2020), round: 2),
        title: '小説つばる「新人SF作家特集号」の依頼',
        url: 'https://kakuyomu.jp/works/1177354054935195606/episodes/1177354054935195646',
        tweet_id: nil,
      )
    end
    let(:twitter_client) { instance_double(TwitterClient) }

    before do
      create(:user, student: work.student, twitter_screen_name: 'fuji_nakahara')
      allow(Rails.configuration.x).to receive(:twitter_client).and_return(twitter_client)
      allow(twitter_client).to receive(:tweet).and_return(
        { 'data' => { 'id' => '1321798802072915980' } },
      )
    end

    it 'tweets and saves tweet_id on the given work' do
      described_class.perform_now(work)

      expect(twitter_client).to have_received(:tweet).with(<<~TWEET)
        【梗概】@fuji_nakahara『小説つばる「新人SF作家特集号」の依頼』
        #裏SF創作講座
        https://genron.sf-ura.site/2020/2
        https://kakuyomu.jp/works/1177354054935195606/episodes/1177354054935195646
      TWEET
      expect(work.reload.tweet_id).not_to be_nil
    end
  end
end
