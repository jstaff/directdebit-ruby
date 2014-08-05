# Version
require 'ezidebit/version'

# Resources
require 'ezidebit/ezidebit_object'
require 'ezidebit/soap_error'
require 'ezidebit/customer'

module Ezidebit
  @api_base = 'https://api.ezidebit.com.au/v3-3/nonpci'
  @api_version = '1.0'

  class << self
    attr_accessor :api_digital_key, :api_base, :api_version
  end

  def self.hi
    puts "Hello world!"
  end

  def self.api_url(url='')
    @api_base + url
  end


end