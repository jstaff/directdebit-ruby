module DirectDebit
  module Securepay
    @api_base = 'https://test.securepay.com.au/xmlapi/payment/'
    @api_version = 'v3-3'
    @api_merchant_id = ''
    @api_merchant_passwd = ''
    @api_timeout = '60'

    class << self
      attr_accessor :api_base, :api_version, :api_merchant_id, :api_merchant_passwd, :api_timeout 
    end

  end
end