# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :student
  has_one :twitter_credential, dependent: :destroy
  has_many :votes, dependent: :delete_all
  has_many :links, dependent: :nullify

  def save_auth_hash!(auth_hash) # rubocop:disable Metrics/AbcSize
    build_student if student.nil?
    build_twitter_credential if twitter_credential.nil?

    unless student.genron_sf_id
      student.assign_attributes(name: auth_hash.info.name, url: auth_hash.info.urls['Twitter'])
    end
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

  def update_by_twitter_user!(twitter_user)
    transaction do
      update!(
        image_url: twitter_user.profile_image_uri_https(:bigger),
        twitter_screen_name: twitter_user.screen_name,
        updated_at: Time.zone.now,
      )
      student.update!(name: twitter_user.name, url: twitter_user.url) unless student.genron_sf_id
    end
  end

  def destroy_with_student!
    transaction do
      destroy!
      student.reload.destroy! unless student.genron_sf_id
    end
  end
end
