# frozen_string_literal: true

class UpdateUserImagesJob < ApplicationJob
  def perform(user_relation: User.all)
    user_relation.find_each do |user|
      image_uri = URI.parse(user.image_url)

      http = Net::HTTP.new(image_uri.host, image_uri.port)
      http.use_ssl = image_uri.scheme == 'https'
      response = http.head(image_uri.path)

      case response
      when Net::HTTPForbidden, Net::HTTPNotFound
        begin
          twitter_user = GenronSFFun::TwitterClient.instance.user(user.twitter_id)
          user.update_by_twitter_user!(twitter_user)
        rescue Twitter::Error::NotFound
          user.destroy!
          Sentry.capture_message('Deleted a user', level: :info, extra: user.as_json)
        end
      else
        response.value
      end

      sleep 0.1
    end
  end
end
