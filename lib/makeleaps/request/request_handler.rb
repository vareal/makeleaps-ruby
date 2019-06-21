module Makeleaps
  module Request
    class RequestHandler
      include ErrorHandler

      attr_reader :connection
      def initialize(connection)
        @connection = connection
      end

      def get(*args, &block)
        response = handle_api_response(success: 200) do
          connection.get(*args, &block)
        end
        Makeleaps::Response::Wrapper.new response
      end

      def post(*args, &block)
        response = handle_api_response(success: 201) do
          connection.post(*args, &block)
        end
        Makeleaps::Response::Wrapper.new response
      end

      def patch(*args, &block)
        response = handle_api_response(success: 200) do
          connection.patch(*args, &block)
        end
        Makeleaps::Response::Wrapper.new response
      end

      def put(*args, &block)
        response = handle_api_response(success: 200) do
          connection.put(*args, &block)
        end
        Makeleaps::Response::Wrapper.new response
      end

      def delete(*args, &block)
        response = handle_api_response(success: 204) do
          connection.delete(*args, &block)
        end
        Makeleaps::Response::Wrapper.new response
      end

      def options(url, &block)
        response = handle_api_response(success: 200) do
          connection.run_request(:options, url, nil, nil, &block)
        end
        Makeleaps::Response::Wrapper.new response
      end
    end
  end
end
