module Makeleaps
  module Response
    class Resource
      attr_accessor :content

      def initialize(content)
        @content = content
      end

      # ensure data are encupslated in an array (for interface consistency)
      def content_as_array
        [content].flatten
      end

      def each_resource(&block)
        if block_given?
          content_as_array.each do |resource|
            block.call(resource)
          end
        else
          content_as_array.to_enum
        end
      end

      def find_resource(*args, &block)
        content_as_array.find(*args, &block)
      end
    end
  end
end
