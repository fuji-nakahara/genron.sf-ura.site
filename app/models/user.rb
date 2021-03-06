# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :student
  has_one :twitter_credential, dependent: :destroy
  has_many :votes, dependent: :delete_all
  has_many :links, dependent: :nullify

  def serializable_hash(options = nil)
    default_options = { only: %i[twitter_id twitter_screen_name] }
    super(default_options.merge(options.to_h))
  end

  def save_auth_hash!(auth_hash)
    transaction do
      if new_record?
        build_student(
          name: auth_hash.info.name,
          url: auth_hash.info.urls['Website'] || auth_hash.info.urls['Twitter'],
          description: auth_hash.info.description,
        )
      end
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

  def preference_object
    UserPreference.new(preference)
  end
end
