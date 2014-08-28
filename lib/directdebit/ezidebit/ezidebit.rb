module DirectDebit
  module Ezidebit
  	@api_base = 'https://api.ezidebit.com.au/'
    @api_version = 'v3-3'

    class << self
      attr_accessor :api_digital_key, :api_base, :api_version
    end

  end
end