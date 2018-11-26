# frozen_string_literal: true

module Epayments
  module Urls
    API_URL = 'https://api.epayments.com'
    TOKEN_URL = API_URL + '/token'
    PAYMENTS_URL = API_URL + '/v2/payments'
    PREFLIGHT_URL = API_URL + '/v2/payments/preflight'
    GET_USER_URL = API_URL + '/v1/get_user'
    EWALLET_URL = API_URL + '/v1/ewallet'
    CURRENCY_EXCHANGE_URL = API_URL + '/v1/currencyexchange'
  end
end
