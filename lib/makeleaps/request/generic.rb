require_relative 'base'
require_relative 'request_handler'
require_relative 'url_manager'

module Makeleaps
  module Request
    class Generic < Base
      attr_reader :handler, :url_manager

      def initialize(access_token)
        super() do |conn|
          conn.authorization :Bearer, access_token
        end
        @handler = Makeleaps::Request::RequestHandler.new(connection)
        @url_manager = Makeleaps::Request::URLManager.new
      end

      def set_partner!(name: )
        url = find_partner_by(name: name)['url']
        partner_mid = url.split('/').last
        url_manager.set_partner!(partner_mid)
        self
      end

      def find_partner_by(name: )
        partners = get(:partner)
        partners.find_resource { |partner| partner['name'] == name }
      end

      # process sequentially (avoid eager loading) to ensure minimum API access
      def each_page(start_page , &block)
        next_url = start_page

        loop do
          response = get(next_url)
          block.call(response)
          next_url = response.next
          break unless next_url
          sleep 0.1 # TODO: throttling parameter can be adjusted individually
        end
      end

      def each_resource(start_page , &block)
        each_page(start_page) do |page|
          page.each_resource do |resource|
            block.call(resource)
          end
        end
      end

      def find_resource(start_page, *args, &block)
        each_page(start_page) do |page|
          resource = page.find_resource(*args, &block)
          return resource if resource
        end
        nil
      end

      def get(resource_or_url, mid=nil, &block)
        handler.get url_manager.build_url_for(resource_or_url, mid), &block
      end

      def post(resource_or_url, mid=nil, &block)
        handler.post url_manager.build_url_for(resource_or_url, mid), &block
      end

      def put(resource_or_url, mid=nil, &block)
        handler.put url_manager.build_url_for(resource_or_url, mid), &block
      end

      def patch(resource_or_url, mid=nil, &block)
        handler.patch url_manager.build_url_for(resource_or_url, mid), &block
      end

      def delete(resource_or_url, mid=nil, &block)
        handler.delete url_manager.build_url_for(resource_or_url, mid), &block
      end

      def options(resource_or_url, mid=nil, &block)
        handler.options url_manager.build_url_for(resource_or_url, mid), &block
      end
    end
  end
end
