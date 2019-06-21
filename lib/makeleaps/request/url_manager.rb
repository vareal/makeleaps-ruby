module Makeleaps
  module Request
    class URLManager
      API_ENDPOINT_BASE = 'https://api.makeleaps.com/api'
      GENERIC_ENDPOINT = "#{API_ENDPOINT_BASE}/partner"
      CURRENCY_ENDPOINT = "#{API_ENDPOINT_BASE}/currency"

      attr_reader :partner_mid

      def set_partner!(partner_mid)
        @partner_mid = partner_mid
      end

      def build_url_for(resource_or_url, mid=nil)
        case resource_or_url
        when String
          resource_or_url # assume its a url
        when :partner
          compose_url GENERIC_ENDPOINT, mid
        when :currency
          compose_url CURRENCY_ENDPOINT
        when :client_contact
          # TODO: ensure that @partner_mid exists
          compose_url GENERIC_ENDPOINT, @partner_mid, :client, mid, :contact
        else
          # TODO: ensure that @partner_mid exists
          compose_url GENERIC_ENDPOINT, @partner_mid, resource_or_url, mid
        end
      end

    private
      def compose_url(*parts)
        [*parts, ''].compact.join('/')
      end
    end
  end
end
