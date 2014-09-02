module DirectDebit
  module Ezidebit
    class Payment  < EzidebitObject

      #TODO: Use Base API URL and add action to it
      ADD_PAYMENT_ACTION = 'https://px.ezidebit.com.au/INonPCIService/AddPayment'
      PAYMENT_DETAIL_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetPaymentDetail'
      GET_PAYMENTS_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetPayments'


      #This method is used to add a single payment to a customer's account
      def self.add_payment(options={})
        response = request_it!(self.xml_type, "nonpci", ADD_PAYMENT_ACTION) do |xml|
          xml['px'].AddPayment do
            xml['px'].DigitalKey DirectDebit::api_digital_key
            options.each { |key,value| xml['px'].send(key, value)}
          end
        end
        parse_add_payment_response(response)
      end

      #This method will get payment details
      def self.get_payment_detail(payment_reference = "")
        response = request_it!(self.xml_type, "nonpci", PAYMENT_DETAIL_ACTION) do |xml|
          xml['px'].GetPaymentDetail do
            xml['px'].DigitalKey DirectDebit::api_digital_key
            xml['px'].PaymentReference payment_reference
          end
        end
        parse_get_payment_detail(response)
      end

      def self.get_payments(date_from = "", date_to = "", date_field = "SETTLEMENT", 
          payment_type = "ALL", payment_method = "DR", payment_source = "SCHEDULED" )
          response = request_it!(self.xml_type, "nonpci", GET_PAYMENTS_ACTION) do |xml|
            xml['px'].GetPayments do
              xml['px'].DigitalKey DirectDebit::api_digital_key
              xml['px'].PaymentType payment_type
              xml['px'].PaymentMethod payment_method
              xml['px'].PaymentSource payment_source
              xml['px'].DateFrom date_from
              xml['px'].DateTo date_to
              xml['px'].DateField date_field
              xml['px'].EziDebitCustomerID ""
              xml['px'].YourSystemReference ""
              xml['px'].YourSystemReference ""
          end
        end
        parse_get_payments(response)
      end

      def self.get_scheduled_payments(date_from = "", date_to = "", ezi_debit_customer_id = "", your_system_reference = "")
          response = request_it!(self.xml_type, "nonpci", GET_SCHEDULED_PAYMENTS_ACTION) do |xml|
            xml['px'].GetScheduledPayments do
              xml['px'].DigitalKey DirectDebit::Ezidebit::api_digital_key
              xml['px'].DateFrom date_from
              xml['px'].DateTo date_to
              xml['px'].EziDebitCustomerID ezi_debit_customer_id
              xml['px'].YourSystemReference your_system_reference
          end
        end
        parse_get_scheduled_payments(response)
      end


      def self.parse_add_payment_response(response)
        if response then
          xml    = Nokogiri::XML(response.body)
          data   = {}
           data[:Status] = xml.xpath("//ns:AddPaymentResponse/ns:AddPaymentResult/ns:Data", 
            {ns: 'https://px.ezidebit.com.au/'} ).text
          data[:Error] = xml.xpath("//ns:AddPaymentResponse/ns:AddPaymentResult/ns:Error", 
            {ns: 'https://px.ezidebit.com.au/'} ).text
          data[:ErrorMessage] = xml.xpath("//ns:AddPaymentResponse/ns:AddPaymentResult/ns:ErrorMessage", 
            {ns: 'https://px.ezidebit.com.au/'} ).text
          return data
        else
          false
        end
      end

      def self.parse_get_payment_detail(response)
        if response then
          xml    = Nokogiri::XML(response.body)
          data   = {}
          fieldnames = ['BankFailedReason', 'BankReturnCode', 'DebitDate', 'InvoiceID', 'PaymentAmount', 'PaymentI',
            'PaymentMethod', 'PaymentReference', 'PaymentStatus', 'SettlementDate', 'ScheduledAmount', 'TransactionFeeClient', 'TransactionFeeCustomer', 
            'TransactionFeeCustomer', 'YourSystemReference']
          fieldnames.each do | fieldname|
            data[fieldname] = xml.xpath("//xmlns:GetPaymnetDetailsResponse/xmlns:GetPaymentDetailsResult/xmlns:Data/xmlns:#{fieldname}",  {xmlns: 'https://px.ezidebit.com.au/'} ).text
          end
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
          Ezidebit.logger.debug  "Payment nodeset count: #{payments_nodeset.count}"
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

      def self.parse_get_payments(response)
        if response then
          test_body=<<-eos
  <s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
   <s:Body>
    <GetPaymentsResponse xmlns="https://px.ezidebit.com.au/">
      <GetPaymentsResult xmlns:i="http://www.w3.org/2001/XMLSchema􏰂instance">
        <Data>
          <Payment>
            <BankFailedReason/>
            <BankReceiptID>430358</BankReceiptID>
            <BankReturnCode>O</BankReturnCode>
            <CustomerName>Test</CustomerName>
            <DebitDate>2014 08 19T00:00:00</DebitDate>
            <EziDebitCustomerID/>
            <InvoiceID>0</InvoiceID>
            <PaymentAmount>100.00</PaymentAmount>
            <PaymentID>48991</PaymentID>
            <PaymentMethod>DR</PaymentMethod>
            <PaymentReference>bond</PaymentReference>
            <PaymentSource>SCHEDULED</PaymentSource>
            <PaymentStatus>P</PaymentStatus>
            <SettlementDate i:nil="true"/>
            <ScheduledAmount>500</ScheduledAmount>
            <TransactionFeeClient>0.99</TransactionFeeClient>
            <TransactionFeeCustomer>0</TransactionFeeCustomer>
            <TransactionTime>2014 08 19T11:45:00</TransactionTime>
            <YourGeneralReference>MP-6</YourGeneralReference>
            <YourSystemReference>MP-6</YourSystemReference>
          </Payment>
          <Payment>
            <BankFailedReason/>
            <BankReceiptID>430358</BankReceiptID>
            <BankReturnCode>O</BankReturnCode>
            <CustomerName>Test</CustomerName>
            <DebitDate>2014 08 19T00:00:00</DebitDate>
            <EziDebitCustomerID/>
            <InvoiceID>0</InvoiceID>
            <PaymentAmount>500</PaymentAmount>
            <PaymentID>48991</PaymentID>
            <PaymentMethod>DR</PaymentMethod>
            <PaymentReference>rent</PaymentReference>
            <PaymentSource>SCHEDULED</PaymentSource>
            <PaymentStatus>P</PaymentStatus>
            <SettlementDate i:nil="true"/>
            <ScheduledAmount>500</ScheduledAmount>
            <TransactionFeeClient>0.99</TransactionFeeClient>
            <TransactionFeeCustomer>0</TransactionFeeCustomer>
            <TransactionTime>2014 08 19T11:45:00</TransactionTime>
            <YourGeneralReference>MP-6</YourGeneralReference>
            <YourSystemReference>MP-6</YourSystemReference>
          </Payment>
          <Payment>
            <BankFailedReason/>
            <BankReceiptID>430358</BankReceiptID>
            <BankReturnCode>O</BankReturnCode>
            <CustomerName>Test</CustomerName>
            <DebitDate>2014 09 19T00:00:00</DebitDate>
            <EziDebitCustomerID/>
            <InvoiceID>0</InvoiceID>
            <PaymentAmount>500</PaymentAmount>
            <PaymentID>48992</PaymentID>
            <PaymentMethod>DR</PaymentMethod>
            <PaymentReference></PaymentReference>
            <PaymentSource>SCHEDULED</PaymentSource>
            <PaymentStatus>P</PaymentStatus>
            <SettlementDate i:nil="true"/>
            <ScheduledAmount>500</ScheduledAmount>
            <TransactionFeeClient>0.99</TransactionFeeClient>
            <TransactionFeeCustomer>0</TransactionFeeCustomer>
            <TransactionTime>2014 09 20T11:45:00</TransactionTime>
            <YourGeneralReference>MP-6</YourGeneralReference>
            <YourSystemReference>MP-6</YourSystemReference>
          </Payment>
        </Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
      </GetPaymentsResult>
    </GetPaymentsResponse>
  </s:Body>
  </s:Envelope>
  eos
          xml    = Nokogiri::XML(test_body)
          payments = []
          fieldnames = ['BankFailedReason', 'BankReceiptID', 'BankReturnCode', 'CustomerName', 'DebitDate', 'EziDebitCustomerID',
            'InvoiceID', 'PaymentAmount', 'PaymentID', 'PaymentMethod', 'PaymentReference', 'PaymentSource', 'PaymentStatus', 'SettlementDate',
            'ScheduledAmount', 'TransactionFeeClient', 'TransactionFeeCustomer', 'TransactionTime', 'YourGeneralReference', 'YourSystemReference']
          payments_nodeset = xml.xpath("//xmlns:GetPaymentsResponse/xmlns:GetPaymentsResult/xmlns:Data/xmlns:Payment",  
            {xmlns: 'https://px.ezidebit.com.au/'} ).map { |node| node}
          Ezidebit.logger.debug  "Payment nodeset count: #{payments_nodeset.count}"
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
end