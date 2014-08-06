module Ezidebit
  class Customer < EzidebitObject

  	#TODO: Use Base API URL and add action to it
    SOAP_ACTION='https://px.ezidebit.com.au/INonPCIService/AddCustomer'

  	def self.add_customer(options={})
	  response = soap_it!(SOAP_ACTION) do |xml|
   	    xml['px'].AddCustomer do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          #xml['px'].YourSystemReference customer_number
          #Nokogiri::XML::Builder uses method missing to build xml elements, 
          #send will still raise method missing and create elements dynamically
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
  	  parse_add_customer_response(response)
    end
  	 
  	def self.change_customer_status
  	end


    def self.parse_add_customer_response(response)
      if response then
        xml    = Nokogiri::XML(response.body)
        data   = {}
        data["CustomerRef"] = xml.xpath("//a:CustomerRef", 
          {a: 'http://schemas.datacontract.org/2004/07/Ezidebit.PaymentExchange.V3_3.DataContracts'}).text
        return data
      else
        false
      end
    end

  end
end