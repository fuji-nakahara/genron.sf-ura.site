# frozen_string_literal: true

class TwitterClient
  class Error < StandardError
    attr_reader :status, :body

    def initialize(env)
      @status = env.status
      begin
        @body = JSON.parse(env.body, simbolized_keys: true)
        super("#{env.status} #{@body[:title]}: #{@body[:detail]}")
      rescue JSON::ParserError
        super("#{env.status}: #{env.body}")
      end
    end
  end

  class ClientError < Error; end
  class UnauthorizedError < ClientError; end
  class ForbiddenError < ClientError; end
  class NotFoundError < ClientError; end
  class ServerError < Error; end
end
