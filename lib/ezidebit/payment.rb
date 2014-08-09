module Ezidebit
  class Payment < EzidebitObject
    #TODO: Use Base API URL and add action to it
    ADD_PAYMENT_ACTION = 'https://px.ezidebit.com.au/INonPCIService/AddPayment'
    PAYMENT_DETAIL_ACTION = 'https://px.ezidebit.com.au/INonPCIService/GetPaymentDetail'

    #This method is used to add a single payment to a customer's account
    def self.add_payment(options={})
      response = soap_it!(ADD_PAYMENT_ACTION) do |xml|
        xml['px'].AddPayment do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          options.each { |key,value| xml['px'].send(key, value)}
        end
      end
      parse_add_payment_response(response)
    end

    #This method will get payment details
    def self.get_payment_detail(payment_reference = "")
      response = soap_it!(PAYMENT_DETAIL_ACTION) do |xml|
        xml['px'].GetPaymentDetail do
          xml['px'].DigitalKey Ezidebit::api_digital_key
          xml['px'].PaymentReference payment_reference
        end
      end
      parse_get_payment_detail(response)
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

  end
end