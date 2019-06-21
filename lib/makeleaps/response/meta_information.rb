require_relative 'hash_access_delegator'

module Makeleaps
  module Response
    class MetaInformation
      extend HashAccessDelegator
      delegate_hash_access '@meta_information', :next, :prev, :page, :count, :status
      attr_accessor :meta_information

      def initialize(meta_information)
        @meta_information = meta_information
      end
    end
  end
end
