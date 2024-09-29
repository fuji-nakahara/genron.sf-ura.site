# frozen_string_literal: true

class TwitterClient
  class Error < StandardError
    attr_reader :status, :body

    def initialize(env)
      @status = env.status
      begin
        @body = JSON.parse(env.body)
        # The token endpoint returns `error` and `error_description``.
        super("#{env.status} #{@body['title'] || @body['error']}: #{@body['detail'] || @body['error_description']}")
      rescue JSON::ParserError
        @body = {}
        super("#{env.status}: #{env.body}")
      end
    end
  end

  class ClientError < Error; end
  class BadRequestError < Error; end
  class UnauthorizedError < ClientError; end
  class ForbiddenError < ClientError; end
  class NotFoundError < ClientError; end
  class ServerError < Error; end
end
