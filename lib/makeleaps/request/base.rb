module Makeleaps
  module Request
    class Base
      ENDPOINT = 'https://api.makeleaps.com/'

      attr_reader :connection
      def initialize(&block)
        @connection = Faraday.new(url: ENDPOINT, headers: {'Accept' => 'application/json', 'Content-Type': 'application/json'}) do |conn|
                        conn.adapter  Faraday.default_adapter
                        block.call(conn) if block_given?
                      end
      end
    end
  end
end
