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

      # set max_pages to change the maximum number of retrievable pages 
      # WARNING: this might invoke too many API accesses.
      def each_page(start_page, *args, params: nil, max_pages: nil, &block)
        next_url = start_page
        max_pages = max_pages || 100 # TODO: let default value be customizeable using config

        max_pages.times do
          response = get(next_url, *args) { |req|
            req.params.merge!(params) unless params.nil?
          }
          block.call(response)
          next_url = response.next
          break unless next_url
          sleep 0.1 # TODO: throttling parameter can be adjusted individually
        end
      end

      # set max_pages to change the maximum number of retrievable pages 
      # WARNING: this might invoke too many API accesses.
      def each_resource(start_page, *args, params: nil, max_pages: nil, &block)
        each_page(start_page, *args, params: params, max_pages: max_pages) do |page|
          page.each_resource do |resource|
            block.call(resource)
          end
        end
      end

      def find_resource(start_page, *args, params: nil, max_pages: nil, &block)
        each_page(start_page, params: params, max_pages: max_pages) do |page|
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
