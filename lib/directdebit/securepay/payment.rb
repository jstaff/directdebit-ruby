module DirectDebit
  module Securepay
    class Payment  < SecurepayObject

      ADD_PAYMENT_ACTION = ''

      def add_payment(options={})
        create_request("nonpci", ADD_PAYMENT_ACTION) do |xml|
          xml.SecurePayMessage do
            add_xml_message_info(xml)
            add_xml_merchant_info(xml)
            xml.RequestType "Payment"
            xml.Payment do
              xml.TxnList do
                xml.Txn do
                  xml.txnType "0"
                  xml.txnSource "0"
                  xml.amount options[:PaymentAmountInCents]
                  xml.CreditCardInfo do
                    xml.cardNumder "4444333322221111"
                    xml.expiryDate "09/15"
                  end
                end
              end
            end
          end
        end
        response = request_it!
        parse(response, "add_payment_response")
      end

      def add_xml_message_info(xml)
        xml.MessageInfo do
          xml.Info1 "test"
          xml.info2 "test2"
        end
      end

      def add_xml_merchant_info(xml)
        xml.MerchantInfo do
         xml.merchantID DirectDebit::Securepay::api_merchant_id
         xml.password DirectDebit::Securepay::api_merchant_passwd
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