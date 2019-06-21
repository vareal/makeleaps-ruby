module Makeleaps
  class Error < StandardError; end

  class APIError < Error
    attr_accessor :status

    def initialize(message, status=nil)
      super(message)
      @status = status
    end
  end

  module ErrorHandler
    def handle_api_response(success: 200, &block)
      response = block.call
      return response if [success].flatten.include? response.status

      message = response.respond_to?(:resource) ? response.resource : response.inspect
      # 'Makeleaps API error'
      raise Makeleaps::APIError.new(message, response.status)
    end
  end
end
