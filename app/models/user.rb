# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :student
  has_one :twitter_credential, dependent: :destroy
  has_many :votes, dependent: :delete_all
  has_many :links, dependent: :nullify

  def save_auth_hash!(auth_hash)
    transaction do
      build_student(name: auth_hash.info.name, url: auth_hash.info.urls['Twitter']) if new_record?
      update!(
        image_url: auth_hash.info.image,
        twitter_screen_name: auth_hash.info.nickname,
        last_logged_in_at: Time.zone.now,
      )
      if auth_hash.provider == 'twitter'
        build_twitter_credential if twitter_credential.nil?
        twitter_credential.update!(
          token: auth_hash.credentials.token,
          secret: auth_hash.credentials.secret,
        )
      end
    end
  end

  def update_by_twitter_user!(twitter_user)
    update!(
      image_url: twitter_user.profile_image_uri_https(:bigger),
      twitter_screen_name: twitter_user.screen_name,
      updated_at: Time.zone.now,
    )
  end
end
