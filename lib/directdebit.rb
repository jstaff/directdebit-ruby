require 'nokogiri'
require 'typhoeus'
require 'logger'

# Version
require 'directdebit/version'

# Resources
require 'directdebit/api_object'
require 'directdebit/util'
require 'directdebit/soap_error'

require 'directdebit/ezidebit/ezidebit'
require 'directdebit/ezidebit/ezidebit_object'
require 'directdebit/ezidebit/customer'
require 'directdebit/ezidebit/payment'

require 'directdebit/securepay/securepay'
require 'directdebit/securepay/securepay_object'
require 'directdebit/securepay/payment'

module DirectDebit

  @logger = Logger.new(STDOUT)
  @logger.level = Logger::WARN

  class << self
    attr_accessor  :logger
  end

end