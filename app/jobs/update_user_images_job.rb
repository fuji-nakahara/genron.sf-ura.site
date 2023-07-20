# frozen_string_literal: true

class UpdateUserImagesJob < ApplicationJob
  Error = Class.new(StandardError)
  Result = Struct.new(:succeeded_count, :updated, :failed, :deactivated)

  def perform(user_relation: User.all)
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
          user.fetch_and_update!
          logger.info "Updated: #{user.previous_changes}"
          result.updated << user.twitter_screen_name
        rescue User::NoRefreshTokenError
          user.deactivate
          logger.info "No refresh token: #{user.id}"
          result.deactivated << user.twitter_screen_name
        rescue TwitterClient::Error => e
          Sentry.capture_exception(e, extra: user.as_json, hint: { background: false })

          # TODO: トークンのリフレッシュ失敗やユーザ退会時の Twitter API v2 の挙動が確認できたら、ユーザ削除を再実装する
          # user.destroy!
          # logger.info "Deleted: #{user.inspect}"
          # result.deleted << user.twitter_screen_name
          # Sentry.capture_message('Deleted a user', level: :info, extra: user.as_json, hint: { background: false })
        end
      when Net::HTTPServiceUnavailable
        logger.warn "Failed: #{response.to_hash})"
        result.failed << user.twitter_screen_name
        sleep 1
      else
        response.value
        result.succeeded_count += 1
      end
    end

    logger.info result.inspect
    raise Error, 'Failed to fetch all of the user images' if result.succeeded_count.zero?
  end
end
