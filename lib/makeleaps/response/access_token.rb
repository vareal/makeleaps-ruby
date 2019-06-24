module Makeleaps
  module Response
    class TokenStore
      attr_reader :response, :body

      def initialize(response)
        @response      = response
        @body = JSON.parse(response.body)
      rescue JSON::JSONError
        @body = nil
      end

      def access_token
        @access_token ||= body['access_token']
      end

      def valid?
        response && response.status == 200 && !expired?
      end

    private

      def expired?
        Time.now >= requested_at + expiration_period
      end

      def requested_at
        Time.parse response.headers['date']
      end

      def expiration_period
        body['expires_in']
      end
    end
  end
end
