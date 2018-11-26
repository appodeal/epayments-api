# frozen_string_literal: true

require 'cgi'

require_relative 'request'
require_relative 'urls'

module Epayments
  class API
    attr_accessor :partner_id, :partner_secret

    def initialize(partner_id, partner_secret)
      @partner_id = partner_id
      @partner_secret = partner_secret
      @access_token = nil
      @token_expires_at = nil
    end

    def token(params)
      Request.perform(:post, URI.parse(Urls::TOKEN_URL), headers_for_token, params.to_s)
    end

    # requisites is the array of requisites hashes
    def payment(params)
      check_token

      Request.perform(:post, URI.parse(Urls::PAYMENTS_URL), headers_for_other, params.to_json)
    end

    def payment_info(payment_id)
      check_token

      Request.perform(:get, URI.parse(Urls::PAYMENTS_URL + "/#{payment_id}"), headers_for_other, '')
    end

    # test payment with no actual processing, to view errors if they exists
    def preflight(params)
      check_token

      Request.perform(:post, URI.parse(Urls::PREFLIGHT_URL), headers_for_other, params.to_json)
    end

    def ewallet
      check_token

      Request.perform(:get, URI.parse(Urls::EWALLET_URL), headers_for_other, '')
    end

    def currency_exchange(params)
      check_token

      Request.perform(:post, URI.parse(Urls::CURRENCY_EXCHANGE_URL), headers_for_other, params.to_json)
    end

    private

    def headers_for_token
      { 'Content-type' => 'application/x-www-form-urlencoded' }
    end

    def headers_for_other
      { 'Content-type' => 'application/json', 'Authorization' => "Bearer #{@access_token}" }
    end

    def check_token
      return if @access_token.present? && @token_expires_at > Time.now

      response = token("grant_type=partner&partner_id=#{@partner_id}"\
                       "&partner_secret=#{CGI.escape(@partner_secret)}")

      @access_token = response['access_token']
      @token_expires_at = Time.now + response['expires_in'].to_i
    end
  end
end
