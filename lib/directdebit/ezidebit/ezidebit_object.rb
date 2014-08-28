module DirectDebit
  module Ezidebit
    class EzidebitObject < DirectDebit::ApiObject
      
      def self.xml_type
        return "soap"
      end

      def self.construct_soap_envelope(&block)
        Nokogiri::XML::Builder.new do |xml|
          xml.Envelope("xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
                      "xmlns:px" => "https://px.ezidebit.com.au/") do
               xml.parent.namespace = xml.parent.namespace_definitions.first
               xml['soapenv'].Header {}
               xml['soapenv'].Body(&block)
            end
        end
      end

    end
  end
end