# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UserImagesUpdateJob, type: :job do
  describe '#perform' do
    let(:image_updated_user) { create(:user) }
    let(:twitter_client) { instance_double(GenronSFFun::TwitterClient) }

    before do
      create_pair(:user).each do |user|
        stub_request(:head, user.image_url).to_return(status: 200)
      end

      stub_request(:head, image_updated_user.image_url).to_return(status: 404)

      allow(GenronSFFun::TwitterClient).to receive(:instance).and_return(twitter_client)
      allow(twitter_client).to receive(:user).with(image_updated_user.twitter_id).and_return(
        instance_double(
          Twitter::User,
          screen_name: image_updated_user.twitter_screen_name,
          profile_image_uri_https: 'https://example.com/new_profile_image.jpeg',
          name: image_updated_user.student.name,
          url: image_updated_user.student.url,
        ),
      )
    end

    it 'updates image_urls of image updated users' do
      described_class.perform_now

      expect(image_updated_user.reload.image_url).to eq 'https://example.com/new_profile_image.jpeg'
    end

    context 'when an image updated user is deleted on Twitter' do
      before do
        allow(twitter_client).to receive(:user).with(image_updated_user.twitter_id).and_raise(Twitter::Error::NotFound)
      end

      it 'destroys the user' do
        described_class.perform_now

        expect { image_updated_user.reload }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
