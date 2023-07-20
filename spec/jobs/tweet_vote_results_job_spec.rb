# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TweetVoteResultsJob do
  describe '#perform' do
    let(:kadai) { create(:kadai, term: create(:term, year: 2020), round: 1) }
    let(:twitter_client) { instance_spy(TwitterClient) }

    before do
      allow(Rails.configuration.x).to receive(:twitter_client).and_return(twitter_client)
    end

    context 'with Kougai type' do
      let(:type) { 'Kougai' }

      before do
        student = create(:student, name: 'フジ・ナカハラ')
        create(:kougai, kadai:, student:, title: '式年遷皇', votes_count: 2)
        create(:kougai, kadai:)
      end

      it 'tweets vote results for kougai' do
        described_class.perform_now(kadai, type:)

        expect(twitter_client).to have_received(:tweet).with(<<~TWEET.chomp)
          現時点での第1回梗概の最高得票作は
          フジ・ナカハラ『式年遷皇』
          で2票です！
          #裏SF創作講座
          https://genron.sf-ura.site/2020/1
        TWEET
      end
    end

    context 'with Jissaku type' do
      let(:type) { 'Jissaku' }

      before do
        student = create(:student, name: 'フジ・ナカハラ')
        create(:jissaku, kadai:, student:, title: 'サイボーグ・クラスメイト', votes_count: 2)
        create(:jissaku, kadai:, student:, title: '透明な血のつながり', votes_count: 2)
        create(:jissaku, kadai:)
      end

      it 'tweets vote results for jissaku' do
        described_class.perform_now(kadai, type:)

        expect(twitter_client).to have_received(:tweet).with(<<~TWEET.chomp)
          現時点での第1回実作の最高得票作は
          フジ・ナカハラ『サイボーグ・クラスメイト』
          フジ・ナカハラ『透明な血のつながり』
          で2票です！
          #裏SF創作講座
          https://genron.sf-ura.site/2020/1
        TWEET
      end
    end
  end
end
