require File.expand_path('../../test_helper', __FILE__)

class CustomerTest < Minitest::Unit::TestCase

  DirectDebit.logger.level = Logger::DEBUG
  DirectDebit::Securepay.api_base="https://test.securepay.com.au/xmlapi"
  DirectDebit::Securepay.api_version="spxml-4.2"
  DirectDebit::Securepay.api_merchant_id='ABC0001'
  DirectDebit::Securepay.api_merchant_passwd='abc123'

  def test_add_one_time_payment_for_debit
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       amount: "123",
       purchaseOrderNo: "INV-1234",
       bsbNumber: "123123",
       accountNumber:  "1234",
       accountName: "John Smith",
       creditFlag: "yes"
    }

    response_body=<<-eos
<?xml version="1.0" encoding="UTF-8"?>
<SecurePayMessage>
    <MessageInfo>
        <messageID>8af793f9af34bea0cf40f5fb750f64</messageID>
        <messageTimestamp>20042303111226938000+660</messageTimestamp>
        <apiVersion>xml-4.2</apiVersion>
    </MessageInfo>
    <MerchantInfo>
        <merchantID>ABC0001</merchantID>
    </MerchantInfo>
    <RequestType>Payment</RequestType>
    <Status>
        <statusCode>000</statusCode>
        <statusDescription>Normal</statusDescription>
    </Status>
    <Payment>
        <TxnList count="1">
             <Txn ID="1">
             <txnType>15</txnType>
             <txnSource>23</txnSource>
             <amount>200</amount>
             <purchaseOrderNo>test</purchaseOrderNo>
             <approved>Yes</approved>
             <responseCode>00</responseCode>
             <responseText>Transaction Accepted</responseText>
             <settlementDate>20040323</settlementDate>
             <txnID>009887</txnID>
             <DirectEntryInfo> 
                 <bsbNumber>123123</bsbNumber> 
                 <accountNumber>0012345</accountNumber>
                 <accountName>John Citizen</accountName>
             </DirectEntryInfo> 
             </Txn>
        </TxnList>
    </Payment>
</SecurePayMessage>
eos
    #TODO: stub the response here
    stub_request(:post, "https://test.securepay.com.au/xmlapi/directentry").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.add_one_time_payment('debit', payment_options)
    puts "#######################"
    puts "response #{response}"
    assert_equal({:statusCode=>"000", :statusDescription=>"Normal"}, response)
  end

 def test_status_error
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       amount: "123",
       purchaseOrderNo: "INV-123",
       accountNumber:  "1234",
       accountName: "John Smith",
       creditFlag: "yes"
    }

    response_body=<<-eos
<SecurePayMessage>
    <Status>
        <statusCode>516</statusCode>
        <statusDescription>Request type unavailable</statusDescription>
    </Status>
</SecurePayMessage>
eos

    stub_request(:post, "https://test.securepay.com.au/xmlapi/directentry").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })
 
    assert_raises DirectDebit::SoapError do 
        payment.add_one_time_payment('debit', payment_options)
    end

end

  def test_response_error
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       amount: "123",
       purchaseOrderNo: "INV-123",
       bsbNumber: "123123A",
       accountNumber:  "1234",
       accountName: "John Smith",
       creditFlag: "yes"
    }

    response_body=<<-eos
<?xml version="1.0" encoding="UTF-8"?>
<SecurePayMessage>
    <MessageInfo>
        <messageID>8af793f9af34bea0cf40f5fb750f64</messageID>
        <messageTimestamp>20042303111226938000+660</messageTimestamp>
        <apiVersion>xml-4.2</apiVersion>
    </MessageInfo>
    <MerchantInfo>
        <merchantID>ABC0001</merchantID>
    </MerchantInfo>
    <RequestType>Payment</RequestType>
    <Status>
        <statusCode>000</statusCode>
        <statusDescription>Normal</statusDescription>
    </Status>
    <Payment>
        <TxnList count="1">
             <Txn ID="1">
             <txnType>0</txnType>
             <txnSource>0</txnSource>
             <amount/>
             <purchaseOrderNo/>
             <settlementDate/>
             <DirectEntryInfo> 
                 <bsbNumber/>
                 <accountNumber/>
                 <accountName/>
             </DirectEntryInfo>
             <approved>No</approved>
             <responseCode>202</responseCode>
             <responseText>Invalid BSB number</responseText>
             </Txn>
        </TxnList>
    </Payment>
</SecurePayMessage>
eos
  
    stub_request(:post, "https://test.securepay.com.au/xmlapi/directentry").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })
 
    assert_raises DirectDebit::SoapError do 
        payment.add_one_time_payment('debit', payment_options)
    end
  end

  def test_add_periodic_payment
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       clientID: "xxxxxx123",
       amount: "123",
       startDate: "20141001",
       numberOfPayments: "12",
       paymentInterval: "30",
       bsbNumber: "123123",
       accountNumber:  "1234",
       accountName: "John Smith",
       creditFlag: "No"
    }

    response_body=<<-eos
<?xml version="1.0" encoding="UTF-8"?>
<SecurePayMessage>
    <MessageInfo>
        <messageID>8af793f9af34bea0cf40f5fb750f64</messageID>
        <messageTimestamp>20042303111226938000+660</messageTimestamp>
        <apiVersion>xml-4.2</apiVersion>
    </MessageInfo>
    <MerchantInfo>
        <merchantID>ABC0001</merchantID>
    </MerchantInfo>
    <RequestType>Periodic</RequestType>
    <Status>
        <statusCode>0</statusCode>
        <statusDescription>Normal</statusDescription>
    </Status>
    <Periodic>
        <PeriodicList count="1">
             <PeriodicItem ID="1">
                 <actionType>add</actionType>
                 <clientID>test</clientID>
                 <responseCode>00</responseCode>
                 <responseText>Successful</responseText>
                 <successful>yes</successful>
                 <DirectEntryInfo>
                    <bsbNumber>1234</bsbNumber>
                    <accountNumber>56789</accountNumber>
                    <accountName>John Smith</accountName>
                 <creditFlag>No</creditFlag>
                 </DirectEntryInfo>
                 <amount>123</amount>
                 <currency>AUD</currency>
                 <periodicType>1</periodicType>
                 <paymentInterval/>
                 <numberOfPayments/>
                 <startDate>20141001</startDate>
                 <endDate>200151001</endDate>
            </PeriodicItem>
        </PeriodicList>
    </Periodic>
</SecurePayMessage>
eos
    #TODO: stub the response here
    stub_request(:post, "https://test.securepay.com.au/xmlapi/periodic").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.add_periodic_payment(payment_options)
    puts "#######################"
    puts "response #{response}"
    assert_equal(
        {:statusCode => "0", 
        :statusDescription => "Normal", 
        :responseCode => "00",
        :responseText => "Successful"}, response)
  end


  def test_delete_periodic_payment
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       clientID: "xxxxxx123"
    }

    response_body=<<-eos
<?xml version="1.0" encoding="UTF-8"?>
<SecurePayMessage>
    <MessageInfo>
        <messageID>8af793f9af34bea0cf40f5fb750f64</messageID>
        <messageTimestamp>20042303111226938000+660</messageTimestamp>
        <apiVersion>xml-4.2</apiVersion>
    </MessageInfo>
    <MerchantInfo>
        <merchantID>ABC0001</merchantID>
    </MerchantInfo>
    <RequestType>Periodic</RequestType>
    <Status>
        <statusCode>0</statusCode>
        <statusDescription>Normal</statusDescription>
    </Status>
    <Periodic>
        <PeriodicList count="1">
             <PeriodicItem ID="1">
                 <actionType>delete</actionType>
                 <clientID>test</clientID>
                 <responseCode>00</responseCode>
                 <responseText>Successful</responseText>
                 <successful>yes</successful>
            </PeriodicItem>
        </PeriodicList>
    </Periodic>
</SecurePayMessage>
eos
    #TODO: stub the response here
    stub_request(:post, "https://test.securepay.com.au/xmlapi/periodic").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.delete_periodic_payment(payment_options)
    puts "#######################"
    puts "response #{response}"
    assert_equal(
        {:statusCode => "0", 
        :statusDescription => "Normal", 
        :responseCode => "00",
        :responseText => "Successful"}, response)
  end

end