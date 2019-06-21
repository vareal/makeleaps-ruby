require_relative 'request'
require_relative 'response'
require 'forwardable'

module Makeleaps
  class Client
    extend Forwardable

    attr_accessor  :partner_mid
    attr_reader    :request
    def_delegators :@request, :get, :post, :put, :patch, :delete, :options
    def_delegators :@request, :each_page, :each_resource, :find_resource, :set_partner!

    def initialize(username, password)
      @auth = Makeleaps::Request::BasicAuth.new(username, password)
    end

    def connect!
      token_store = @auth.make_request!
      @request = Makeleaps::Request::Generic.new(token_store.access_token)
    end

    def connection
      request.connection
    end
  end
end
