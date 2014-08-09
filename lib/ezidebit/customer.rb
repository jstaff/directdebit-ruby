module Ezidebit
  class Customer < EzidebitObject

  	#TODO: Use Base API URL and add action to it
    SOAP_ACTION='https://px.ezidebit.com.au/INonPCIService/AddCustomer'
    UPDATE_STATUS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/ChangeCustomerStatus'
    GET_INFO_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetCustomerDetails'
    EDIT_BANK_ACCOUNT = 'https://px.ezidebit.com.au/IPCIService/EditCustomerBankAccount'

  	#This method will add a new customer.
    def self.add_customer(options={})
      response = soap_it!(SOAP_ACTION) do |xml|
   	    xml['px'].AddCustomer do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
  	  parse_add_customer_response(response)
    end

    #This method retrieves details about the given Customer.
    def self.get_customer_details(ezi_debit_customer_id = "", your_system_reference = "")
      response = soap_it!(GET_INFO_ACTION) do |xml|
        xml['px'].GetCustomerDetails do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          xml['px'].EziDebitCustomerID ezi_debit_customer_id
          xml['px'].YourSystemReference your_system_reference
        end
      end
      parse_get_customer_details(response)
    end
  	 
    #This method will change the status of a customer.
  	def self.change_customer_status(options={})
      response = soap_it!(UPDATE_STATUS_ACTION) do |xml|
        xml['px'].ChangeCustomerStatus do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_change_customer_status_response(response)
  	end

    #This method will either create a new bank account for a customer or update the bank account if already exists
    def self.edit_bank_account(options={})
      response = soap_it!(true, EDIT_BANK_ACCOUNT) do |xml|
        xml['px'].EditCustomerBankAccount do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_edit_bank_account_response(response)
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

    def self.parse_get_customer_details(response)
      if response then
        xml    = Nokogiri::XML(response.body)
        data   = {}
        fieldnames = ['AddressLine1', 'AddressLine2', 'AddressPostCode', 'AddressState', 'AddressSuburb', 'ContractStartDate',
          'CustomerFirstName', 'CustomerName', 'Email', 'EziDebitCustomerID', 'MobilePhone', 'PaymentMethod', 'PaymentPeriod', 
          'PaymentPeriodDayOfMonth', 'PaymentPeriodDayOfWeek', 'SmsExpiredCard', 'SmsFailedNotification', 'SmsPaymentReminder',
          'StatusCode', 'StatusDescription', 'TotalPaymentsFailed', 'TotalPaymentsFailedAmount', 'TotalPaymentsSuccessful', 
          'TotalPaymentsSuccessfulAmount', 'YourGeneralReference', 'YourSystemReference']
        fieldnames.each do | fieldname|
          data[fieldname] = xml.xpath("//xmlns:GetCustomerDetailsResponse/xmlns:GetCustomerDetailsResult/xmlns:Data/xmlns:#{fieldname}",  {xmlns: 'https://px.ezidebit.com.au/'} ).text
        end
        return data
      else
        false
      end
    end

    def self.parse_edit_bank_account_response(response)
      if response then
        xml    = Nokogiri::XML(response.body)
        data   = {}
        data[:Status] = xml.xpath("//ns:EditCustomerBankAccountResponse/ns:EditCustomerBankAccountResult/ns:Data", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:Error] = xml.xpath("//ns:EditCustomerBankAccountResponse/ns:EditCustomerBankAccountResult/ns:Error", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:ErrorMessage] = xml.xpath("//ns:EditCustomerBankAccountResponse/ns:EditCustomerBankAccountResult/ns:ErrorMessage", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        return data
      else
        false
      end
    end

  end
end