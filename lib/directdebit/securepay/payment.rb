module DirectDebit
  module Securepay
    class Payment  < SecurepayObject

      TRANSACTION_TYPES = {
        0 => "Standard Payment",
        1 => "Mobile Payment",
        2 => "Batch Payment",
        3 => "Periodic Payment",
        4 => "Refund",
        5 => "Error Reversal",
        6 => "Client Reversal (Void)",
        10 => "Preauthorise",
        11 => "Preauth Complete (Advice)",
        14 => "Recurring Payment",
        15 => "Direct Entry Debit",
        17 => "Direct Entry Credit ",
        19 => "Card-Present Payment",
        20 => "IVR Payment"
      }

      DEFAULT_TRANSACTION_SOURCE = 23 #FROM XML

      def add_one_time_payment(payment_type='debit', options={})
        create_request do |xml|
          xml.SecurePayMessage do
            add_message_merchant_info(xml)
            xml.RequestType "Payment"
            xml.Payment do
              xml.TxnList(:count => 1) do
                 txn_type_code = TRANSACTION_TYPES.index('Direct Entry Debit') if payment_type == 'debit'
                 txn_type_code = TRANSACTION_TYPES.index('Standard Payment') if payment_type =='credit'
                 add_xml_transaction_item(xml, txn_type_code, options)
              end
            end
          end
        end
        response = request_it!
        parse(response, "add_payment_response")
      end

      def add_periodic_payment(options={})
        create_request do |xml|
          xml.SecurePayMessage do
            add_message_merchant_info(xml)
            xml.RequestType "Peridoc"
            xml.Periodic do
              xml.PeriodicList(:count => 1) do
                add_xml_perodic_item(xml, "add" ,"debit", options)
              end
            end
          end
        end
        response = request_it!
        parse(response, "add_payment_response")
      end

      def add_message_merchant_info(xml)
         add_xml_message_info(xml)
         add_xml_merchant_info(xml)
      end

      def add_xml_transaction_item(xml, txn_type="", options={})
        xml.Txn do
          xml.txnType txn_type
          xml.txnSource DEFAULT_TRANSACTION_SOURCE
          xml.purchaseOrderNo options[:purchaseOrderNo]
          xml.amount options[:amount]
          add_xml_credit_card_info(xml, options) if  [0,4, 6, 10, 11].include?(txn_type) #credit types
          add_xml_direct_entry_info(xml, options) if [15, 17].include?(txn_type) #direct debit types
        end
      end

      def add_xml_perodic_item(xml, action_type="", payment_type="", options={})
        xml.PeriodicItem(:ID => 1) do
          xml.actionType "add" if action_type == "add"
          xml.actionType "delete" if action_type == "delete"
          xml.actionType "trigger" if action_type == "trigger"
          xml.clientID options[:clientID]
          xml.amount options[:amount]
          xml.startDate options[:startDate]
          xml.numberOfPayments options[:numberOfPayments]
          add_xml_credit_card_info(xml, options) if payment_type == "credit"
          add_xml_direct_entry_info(xml, options) if payment_type == "debit"     
        end
      end

      def add_xml_message_info(xml)
        xml.MessageInfo do
          xml.messageId "#{rand(10000)}#{(Time.now.to_f * 1000).to_i}"
          xml.messageTimestamp Time.now.strftime("%Y%d%m%H%M%S%L000s010")
          xml.apiVersion DirectDebit::Securepay.api_version
          xml.timeoutValue DirectDebit::Securepay::api_timeout
        end
      end

      def add_xml_merchant_info(xml)
        xml.MerchantInfo do
         xml.merchantID DirectDebit::Securepay::api_merchant_id
         xml.password DirectDebit::Securepay::api_merchant_passwd
        end
      end

      def add_xml_credit_card_info(xml, options={})
        xml.CreditCardInfo do
          xml.cardNumder options[:cardNumber]
          xml.ccv options[:ccv] || ""
          xml.expiryDate options[:expiryDate]
        end 
      end

      def add_xml_direct_entry_info(xml, options={})
        xml.DirectEntryInfo do
         xml.bsbNumber options[:bsbNumber]
         xml.accountNumber options[:accountNumber]
         xml.accountName options[:accountName]
         xml.creditFlag  options[:creditFlag] || "No"
        end
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


      def parse_add_payment_response(xml)
        data   = {}
         data[:Status] = xml.xpath("//ns:AddPaymentResponse/ns:AddPaymentResult/ns:Data", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:Error] = xml.xpath("//ns:AddPaymentResponse/ns:AddPaymentResult/ns:Error", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data[:ErrorMessage] = xml.xpath("//ns:AddPaymentResponse/ns:AddPaymentResult/ns:ErrorMessage", 
          {ns: 'https://px.ezidebit.com.au/'} ).text
        data
      end
    end   
  end
end