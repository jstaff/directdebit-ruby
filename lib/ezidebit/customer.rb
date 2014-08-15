module Ezidebit
  class Customer < EzidebitObject

  	#TODO: Use Base API URL and add action to it
    ADD_CUSTOMER_ACTION='https://px.ezidebit.com.au/INonPCIService/AddCustomer'
    EDIT_CUSTOMER_ACTION='https://px.ezidebit.com.au/INonPCIService/EditCustomerDetails'
    UPDATE_STATUS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/ChangeCustomerStatus'
    GET_INFO_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetCustomerDetails'
    EDIT_BANK_ACCOUNT_ACTION = 'https://px.ezidebit.com.au/IPCIService/EditCustomerBankAccount'
    CREATE_SCHEDULE_ACTION = 'https://px.ezidebit.com.au/INonPCIService/CreateSchedule'
    GET_SCHEDULED_PAYMENTS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetScheduledPayments'
    ADD_BANK_DEBIT_ACTION = 'https://px.ezidebit.com.au/IPCIService/AddBankDebit'

  	#This method will add a new customer.
    def self.add_customer(options={})
      response = soap_it!(ADD_CUSTOMER_ACTION) do |xml|
   	    xml['px'].AddCustomer do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
  	  parse_add_customer_response(response)
    end

    #This method will add a new customer.
    def self.edit_customer(options={})
      response = soap_it!(EDIT_CUSTOMER_ACTION) do |xml|
        xml['px'].EditCustomerDetails do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_generic_status_response(response, 'EditCustomerDetailsResponse')
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
      parse_generic_status_response(response, 'ChangeCustomerStatus')
  	end

    #This method will either create a new bank account for a customer or update the bank account if already exists
    def self.edit_bank_account(options={})
      response = soap_it!(true, EDIT_BANK_ACCOUNT_ACTION) do |xml|
        xml['px'].EditCustomerBankAccount do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_generic_status_response(response, 'EditCustomerBankAccount')
    end


    #This method will either create payment schedule for a customer
    def self.create_schedule(options={})
        response = soap_it!(CREATE_SCHEDULE_ACTION) do |xml|
        xml['px'].CreateSchedule do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_generic_status_response(response, 'CreateSchedule')
    end

    def self.get_scheduled_payments(date_from = "", date_to = "", ezi_debit_customer_id = "", your_system_reference = "")
        response = soap_it!(GET_SCHEDULED_PAYMENTS_ACTION) do |xml|
          xml['px'].GetScheduledPayments do
            xml['px'].DigitalKey Ezidebit::api_digital_key
            xml['px'].DateFrom date_from
            xml['px'].DateTo date_to
            xml['px'].EziDebitCustomerID ezi_debit_customer_id
            xml['px'].YourSystemReference your_system_reference
        end
      end
      parse_get_scheduled_payments(response)
    end

    #Add/Edit customer and payment
    def self.add_bank_debit(options={})
      response = soap_it!(true, ADD_BANK_DEBIT_ACTION) do |xml|
          xml['px'].AddBankDebit do
            xml['px'].DigitalKey Ezidebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_add_bank_debit_response(response)
    end

    def self.parse_add_bank_debit_response(response)
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
          data[fieldname] = xml.xpath("//xmlns:GetCustomerDetailsResponse/xmlns:GetCustomerDetailsResult/xmlns:Data/xmlns:#{fieldname}",  
            {xmlns: 'https://px.ezidebit.com.au/'} ).text
        end
        return data
      else
        false
      end
    end

    def self.parse_generic_status_response(response, method_name)
      if response then
        xml    = Nokogiri::XML(response.body)
        data   = {}
        data[:Status] = xml.xpath("//ns:#{method_name}Response/ns:#{method_name}Result/ns:Data", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:Error] = xml.xpath("//ns:#{method_name}Response/ns:#{method_name}Result/ns:Error", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:ErrorMessage] = xml.xpath("//ns:#{method_name}Response/ns:#{method_name}Result/ns:ErrorMessage", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        return data
      else
        false
      end 
    end

     def self.parse_get_scheduled_payments(response)
      if response then
        xml    = Nokogiri::XML(response.body)
        payments = []
        fieldnames = ['EziDebitCustomerID', 'YourSystemReference', 'YourGeneralReference', 'PaymentDate', 'PaymentAmount', 'PaymentReference',
          'ManuallyAddedPayment']
        payments_nodeset = xml.xpath("//xmlns:GetScheduledPaymentsResponse/xmlns:GetScheduledPaymentsResult/xmlns:Data/xmlns:ScheduledPayment",  
          {xmlns: 'https://px.ezidebit.com.au/'} ).map { |node| node}
        puts "Payment nodeset count: #{payments_nodeset.count}"
        payments_nodeset.each do |payment_node|
          data = Hash.new
          fieldnames.each do | fieldname|
            data[fieldname] = payment_node.xpath("ns:#{fieldname}",  
              {ns: 'https://px.ezidebit.com.au/'} ).text
          end
          payments << data
        end
        return payments
      else
        false
      end
    end

  end
end