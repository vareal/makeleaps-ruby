require_relative 'base'

module Makeleaps
  module Request
    class BasicAuth < Base
      include ErrorHandler

      AUTH_ENDPOINT = 'user/oauth2/token/'

      def initialize(username, password)
        super() do |conn|
          conn.basic_auth(username, password)
        end
      end

      def make_request!
        response = handle_api_response do
          connection.post(AUTH_ENDPOINT) { |req| req.params['grant_type'] = 'client_credentials'}
        end
        Makeleaps::Response::TokenStore.new response
      end
    end
  end
end
