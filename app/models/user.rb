# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :student
  has_one :twitter_credential, dependent: :destroy
  has_many :votes, dependent: :delete_all

  def save_auth_hash!(auth_hash) # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    if student.nil?
      if (candidate = StudentTwitterCandidate.find_by(twitter_screen_name: auth_hash.info.nickname))
        Raven.capture_message(
          '受講生がログインした可能性があります',
          level: :info,
          extra: {
            genron_sf_id: candidate.genron_sf_id,
            genron_sf_url: candidate.student&.url,
            twitter_url: auth_hash.info.urls['Twitter'],
          },
        )
      end
      build_student
    end

    build_twitter_credential if twitter_credential.nil?

    student.assign_attributes(name: auth_hash.info.name, url: auth_hash.info.urls['Twitter']) unless student.genron_sf_id
    assign_attributes(
      image_url: auth_hash.info.image,
      twitter_screen_name: auth_hash.info.nickname,
      last_logged_in_at: Time.zone.now,
    )
    twitter_credential.assign_attributes(
      token: auth_hash.credentials.token,
      secret: auth_hash.credentials.secret,
    )

    transaction do
      student.save!
      save!
      twitter_credential.save!
    end
  end
end
