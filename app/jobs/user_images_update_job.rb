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
          user.update_by_twitter_user!(twitter_user)
        rescue Twitter::Error::NotFound
          user.destroy!
        end
      end
    end
  end
end
