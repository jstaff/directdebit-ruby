module DirectDebit
  module Securepay
    class SecurepayObject < DirectDebit::ApiObject
      
      def self.xml_type
        return "xml"
      end

      def self.api_url(url='')       
          DirectDebit::Securepay.api_base + "/" + url
      end
    
    end
  end
end