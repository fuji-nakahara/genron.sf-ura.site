# frozen_string_literal: true

class UpdateUserImagesJob < ApplicationJob
  Result = Struct.new(:succeeded_count, :updated, :failed, :deleted)

  def perform(user_relation: User.all, sleep_duration: 0.1)
    result = Result.new(0, [], [], [])

    user_relation.find_each do |user|
      logger.info "Processing: #{user.as_json(only: %i[id twitter_screen_name image_url])}"

      image_uri = URI.parse(user.image_url)
      http = Net::HTTP.new(image_uri.host, image_uri.port)
      http.use_ssl = image_uri.scheme == 'https'
      response = http.head(image_uri.path)

      case response
      when Net::HTTPForbidden, Net::HTTPNotFound
        begin
          twitter_user = GenronSFFun::TwitterClient.instance.user(user.twitter_id)
          user.update_by_twitter_user!(twitter_user)
          logger.info "Updated: #{user.previous_changes}"
          result.updated << user.twitter_screen_name
        rescue Twitter::Error::NotFound
          user.destroy!
          logger.info "Deleted: #{user.inspect}"
          result.deleted << user.twitter_screen_name
          Sentry.capture_message('Deleted a user', level: :info, extra: user.as_json)
        end
      when Net::HTTPServiceUnavailable
        logger.warn "Failed: #{response.to_hash})"
        result.failed << user.twitter_screen_name
      else
        response.value
        result.succeeded_count += 1
      end

      sleep sleep_duration
    end

    logger.info result.inspect
    Sentry.capture_message('Updated user images', level: :info, extra: result.to_h)
  end
end
