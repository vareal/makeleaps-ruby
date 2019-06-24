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
    def_delegators :@request, :connection

    def initialize(username, password)
      @auth_request = Makeleaps::Request::BasicAuth.new(username, password)
    end

    def connect!
      @token_store ||= @auth_request.authenticate!
      @request = Makeleaps::Request::Generic.new(@token_store.access_token) if @token_store.valid?
    end

    def disconnect!
      @auth_request.revoke!(@token_store.access_token) if @token_store&.valid?
      @token_store = nil
    end
  end
end
