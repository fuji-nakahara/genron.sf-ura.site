# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :student
  has_one :twitter_credential, dependent: :destroy

  def save_auth_hash!(auth_hash) # rubocop:disable Metrics/AbcSize
    build_student if student.nil?
    build_twitter_credential if twitter_credential.nil?

    student.assign_attributes(
      name: auth_hash.info.name,
      url: auth_hash.info.urls['Twitter'],
    )
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
