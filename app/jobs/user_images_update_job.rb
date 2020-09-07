# frozen_string_literal: true

class UserImagesUpdateJob < ApplicationJob
  def perform(user_relation: User.all)
    user_relation.find_each do |user|
      image_uri = URI.parse(user.image_url)

      http = Net::HTTP.new(image_uri.host, image_uri.port)
      http.use_ssl = image_uri.scheme == 'https'
      response = http.head(image_uri.path)

      case response
      when Net::HTTPNotFound
        begin
          twitter_user = GenronSFFun::TwitterClient.instance.user(user.twitter_id)
          user.update!(
            twitter_screen_name: twitter_user.screen_name,
            image_url: twitter_user.profile_image_uri_https(:bigger),
          )
        rescue Twitter::Error::NotFound => e
          Raven.capture_exception(e, extra: { user_id: user.id, twitter_id: user.twitter_id })
        end
      end
    end
  end
end
