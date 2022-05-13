require_relative 'base'

module Makeleaps
  module Request
    class BasicAuth < Base
      include ErrorHandler

      AUTH_ENDPOINT       = 'user/oauth2/token/'
      REVOCATKON_ENDPOINT = 'user/oauth2/revoke-token/'

      def initialize(username, password)
        super() do |conn|
          conn.set_basic_auth(username, password)
        end
      end

      def authenticate!
        response = handle_api_response do
          connection.post(AUTH_ENDPOINT) do |req|
            req.headers['Content-Type'] = 'application/x-www-form-urlencoded'
            data = { grant_type: 'client_credentials' }
            req.body = URI.encode_www_form(data)
          end
        end
        Makeleaps::Response::TokenStore.new response
      end

      def revoke!(token)
        handle_api_response do
          connection.post(REVOCATKON_ENDPOINT) { |req| req.params['token'] = token }
        end
      end
    end
  end
end
