# frozen_string_literal: true

require 'net/http'
require 'openssl'
require 'json'

module Epayments
  class Request
    class << self
      def perform(method, uri, headers, body)
        raise "Unsupported method #{method}" unless %w[post get].include?(method.to_s)
        http = prepare_http(uri)
        request = prepare_request(method, uri, headers, body)
        response = http.request(request)
        check_response(response)

        JSON.parse(response.body)
      end

      def prepare_http(uri)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        http
      end

      def prepare_request(method, uri, headers, body)
        request = "Net::HTTP::#{method.capitalize}".constantize.new(uri.request_uri)
        request.body = body
        set_headers(request, headers)

        request
      end

      def set_headers(request, headers)
        headers.each { |key, value| request[key] = value }
      end

      def check_response(response)
        return unless response.class == Net::HTTPBadRequest

        raise "Bad request! Response code: #{response.code}, body: #{response.body}"
      end
    end
  end
end
