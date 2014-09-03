module DirectDebit
  module Ezidebit
    class Customer < EzidebitObject

      ADD_CUSTOMER_ACTION='https://px.ezidebit.com.au/INonPCIService/AddCustomer'
      EDIT_CUSTOMER_ACTION='https://px.ezidebit.com.au/INonPCIService/EditCustomerDetails'
      UPDATE_STATUS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/ChangeCustomerStatus'
      GET_INFO_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetCustomerDetails'
      EDIT_BANK_ACCOUNT_ACTION = 'https://px.ezidebit.com.au/IPCIService/EditCustomerBankAccount'
      CREATE_SCHEDULE_ACTION = 'https://px.ezidebit.com.au/INonPCIService/CreateSchedule'
      GET_SCHEDULED_PAYMENTS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetScheduledPayments'
      ADD_BANK_DEBIT_ACTION = 'https://px.ezidebit.com.au/IPCIService/AddBankDebit'


    	#This method will add a new customer.
      def add_customer(options={})
        create_request("nonpci", ADD_CUSTOMER_ACTION) do |xml|
     	    xml['px'].AddCustomer do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        response = request_it!
        parse(response, "add_customer_response")
      end

      #This method will add a new customer.
      def edit_customer(options={})
        create_request("nonpci", EDIT_CUSTOMER_ACTION) do |xml|
          xml['px'].EditCustomerDetails do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        response = request_it!
        parse(response, "generic_status_response", 'EditCustomerDetails')
      end

      #This method retrieves details about the given Customer.
      def get_customer_details(ezi_debit_customer_id = "", your_system_reference = "")
        create_request("nonpci", GET_INFO_ACTION) do |xml|
          xml['px'].GetCustomerDetails do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            xml['px'].EziDebitCustomerID ezi_debit_customer_id
            xml['px'].YourSystemReference your_system_reference
          end
        end
        response = request_it!
        parse(response, "get_customer_details")
      end
    	 
      #This method will change the status of a customer.
    	def change_customer_status(options={})
        create_request("nonpci", UPDATE_STATUS_ACTION) do |xml|
          xml['px'].ChangeCustomerStatus do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        response = request_it!
        parse(response, "generic_status_response", 'ChangeCustomerStatus')
    	end

      #This method will either create a new bank account for a customer or update the bank account if already exists
      def edit_bank_account(options={})
        create_request("pci", EDIT_BANK_ACCOUNT_ACTION) do |xml|
          xml['px'].EditCustomerBankAccount do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        response = request_it!
        parse(response, "generic_status_response", 'EditCustomerBankAccount')
      end


      #This method will either create payment schedule for a customer
      def create_schedule(options={})
        create_request("nonpci", CREATE_SCHEDULE_ACTION) do |xml|
        xml['px'].CreateSchedule do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        response = request_it!
        parse(response, "generic_status_response", 'CreateSchedule')
      end

      #Add/Edit customer and payment
      def add_bank_debit(options={})
        create_request("pci", ADD_BANK_DEBIT_ACTION) do |xml|
            xml['px'].AddBankDebit do
            xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        response = request_it!
        parse(response, "add_bank_debit_response")
      end

      def parse(response, type, generic_tag = nil)
        if response
          xml = Nokogiri::XML(response.body)
          if(generic_tag == nil)
            return self.send("parse_#{type}", xml)
          else
            return self.send("parse_#{type}", xml, generic_tag)
          end
        else
         return false
        end
      end

      def parse_add_bank_debit_response(xml)
        data   = {}
        data[:CustomerRef] = xml.xpath("//a:CustomerRef", 
          {a: 'http://schemas.datacontract.org/2004/07/Ezidebit.PaymentExchange.V3_3.DataContracts'}).text
        data
      end    

      def parse_add_customer_response(xml)
        data   = {}
        data[:CustomerRef] = xml.xpath("//a:CustomerRef", 
          {a: 'http://schemas.datacontract.org/2004/07/Ezidebit.PaymentExchange.V3_3.DataContracts'}).text
        data
      end

      def parse_get_customer_details(xml)
        data   = {}
        fieldnames = ['AddressLine1', 'AddressLine2', 'AddressPostCode', 'AddressState', 'AddressSuburb', 'ContractStartDate',
          'CustomerFirstName', 'CustomerName', 'Email', 'EziDebitCustomerID', 'MobilePhone', 'PaymentMethod', 'PaymentPeriod', 
          'PaymentPeriodDayOfMonth', 'PaymentPeriodDayOfWeek', 'SmsExpiredCard', 'SmsFailedNotification', 'SmsPaymentReminder',
          'StatusCode', 'StatusDescription', 'TotalPaymentsFailed', 'TotalPaymentsFailedAmount', 'TotalPaymentsSuccessful', 
          'TotalPaymentsSuccessfulAmount', 'YourGeneralReference', 'YourSystemReference']
        fieldnames.each do | fieldname|
          data[fieldname] = xml.xpath("//xmlns:GetCustomerDetailsResponse/xmlns:GetCustomerDetailsResult/xmlns:Data/xmlns:#{fieldname}",  
            {xmlns: 'https://px.ezidebit.com.au/'} ).text
        end
        data
      end

      def parse_generic_status_response(xml, method_name)
        data   = {}
        data[:Status] = xml.xpath("//ns:#{method_name}Response/ns:#{method_name}Result/ns:Data", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:Error] = xml.xpath("//ns:#{method_name}Response/ns:#{method_name}Result/ns:Error", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:ErrorMessage] = xml.xpath("//ns:#{method_name}Response/ns:#{method_name}Result/ns:ErrorMessage", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data
      end

    end
  end
end