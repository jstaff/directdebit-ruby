# Resources
require 'ezidebit/ezidebit_object'

module Ezidebit
  @api_base = 'https://api.ezidebit.com.au/v3-3/nonpci'

  @verify_ssl_certs = true
  @CERTIFICATE_VERIFIED = false

  class << self
    attr_accessor :api_key, :api_base, :verify_ssl_certs, :api_version
  end

  def self.hi
    puts "Hello world!"
  end

  def self.api_url(url='')
    @api_base + url
  end


end