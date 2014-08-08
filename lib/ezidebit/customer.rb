module Ezidebit
  class Customer < EzidebitObject

  	#TODO: Use Base API URL and add action to it
    SOAP_ACTION='https://px.ezidebit.com.au/INonPCIService/AddCustomer'
    UPDATE_STATUS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/ChangeCustomerStatus'

  	def self.add_customer(options={})
        response = soap_it!(SOAP_ACTION) do |xml|
   	    xml['px'].AddCustomer do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
  	  parse_add_customer_response(response)
    end
  	 
  	def self.change_customer_status(options={})
        response = soap_it!(UPDATE_STATUS_ACTION) do |xml|
        xml['px'].ChangeCustomerStatus do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_change_customer_status_response(response)
  	end

    def self.parse_add_customer_response(response)
      if response then
        xml    = Nokogiri::XML(response.body)
        data   = {}
        data[:CustomerRef] = xml.xpath("//a:CustomerRef", 
          {a: 'http://schemas.datacontract.org/2004/07/Ezidebit.PaymentExchange.V3_3.DataContracts'}).text
        return data
      else
        false
      end
    end

    def self.parse_change_customer_status_response(response)
      if response then
        xml    = Nokogiri::XML(response.body)
        data   = {}
        data[:Status] = xml.xpath("//ns:ChangeCustomerStatusResponse/Data", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        return data
      else
        false
      end
    end

  end
end