# frozen_string_literal: true

class User < ApplicationRecord
  belongs_to :student
  has_one :twitter_credential, dependent: :destroy
  has_one :twitter2_credential, dependent: :destroy
  has_many :votes, dependent: :delete_all
  has_many :links, dependent: :nullify
  has_many :student_merge_candidates, dependent: :delete_all

  scope :active, -> { where(deactivated_at: nil) }

  def serializable_hash(options = nil)
    default_options = { only: %i[twitter_id twitter_screen_name image_url] }
    super(default_options.merge(options.to_h))
  end

  def save_auth_hash!(auth_hash)
    transaction do
      if new_record?
        build_student(
          name: auth_hash.info.name,
          url: auth_hash.info.urls['Twitter'],
          description: auth_hash.info.description,
        )
      end
      update!(
        image_url: auth_hash.info.image,
        twitter_screen_name: auth_hash.info.nickname,
        deactivated_at: nil,
        last_logged_in_at: Time.zone.now,
      )
      if auth_hash.provider == 'twitter2'
        build_twitter2_credential if twitter2_credential.nil?
        twitter2_credential.update!(
          refresh_token: auth_hash.credentials.refresh_token,
          token: auth_hash.credentials.token,
          expires_at: Time.zone.at(auth_hash.credentials.expires_at),
        )
      end
    end
  end

  def fetch_and_update!
    token = twitter2_credential.fetch_valid_token!
    client = TwitterClient.with_oauth2(bearer_token: token)
    response = client.me({ 'user.fields' => 'profile_image_url' })
    data = response.fetch('data')

    update!(
      twitter_screen_name: data.fetch('username'),
      image_url: data.fetch('profile_image_url'),
    )
  end

  def deactivate
    touch(:deactivated_at) # rubocop:disable Rails/SkipsModelValidations
  end

  def preference_object
    UserPreference.new(preference)
  end
end
