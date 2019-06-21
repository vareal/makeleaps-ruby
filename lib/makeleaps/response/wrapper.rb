require 'forwardable'
require_relative 'meta_information'
require_relative 'resource'

module Makeleaps
  module Response
    class Wrapper
      extend Forwardable

      attr_reader :body, :status, :meta_information, :resource
      def_delegators :@meta_information, :next, :prev, :page, :count, :status
      def_delegators :@resource, :each_resource, :find_resource

      def initialize(raw_response)
        @status = raw_response.status
      begin
        @body = JSON.parse(raw_response.body)
      rescue JSON::JSONError
        # TODO: to raise an original error?
        @body = {}
      end
        @meta_information = MetaInformation.new @body['meta']
        @resource         = Resource.new @body['response']
      end
    end
  end
end
