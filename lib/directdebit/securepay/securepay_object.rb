module DirectDebit
  module Securepay
    class SecurepayObject < DirectDebit::ApiObject
      
      def self.xml_type
        return "xml"
      end

      def self.api_url(url='')
        if  url != ''
          DirectDebit::Securepay.api_base + DirectDebit::Securepay.api_version + "/" + url
        else
          DirectDebit::Securepay.api_base + DirectDebit::Securepay.api_version
        end
      end
    
    end
  end
end