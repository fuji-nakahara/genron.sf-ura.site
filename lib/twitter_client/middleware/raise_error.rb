# frozen_string_literal: true

require_relative '../error'

class TwitterClient
  module Middleware
    class RaiseError < Faraday::Middleware
      def on_complete(env)
        case env.status
        when 400
          raise BadRequestError, env
        when 401
          raise UnauthorizedError, env
        when 403
          raise ForbiddenError, env
        when 400...500
          raise ClientError, env
        when 500...600
          raise ServerError, env
        end
      end
    end
  end
end
