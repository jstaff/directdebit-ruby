module Ezidebit
  class Customer < EzidebitObject

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
  	  #parse_customer_response(response)
	end
  	 
  	def self.change_customer_status
  	end

  end
end