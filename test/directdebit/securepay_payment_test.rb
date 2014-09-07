require File.expand_path('../../test_helper', __FILE__)

class CustomerTest < Minitest::Unit::TestCase

  DirectDebit.logger.level = Logger::DEBUG
  DirectDebit::Securepay.api_base="https://test.securepay.com.au/xmlapi/directentry/"
  DirectDebit::Securepay.api_version="spxml-4.2"
  DirectDebit::Securepay.api_merchant_id='ABC0001'
  DirectDebit::Securepay.api_merchant_passwd='changit!'

  def test_add_one_time_payment_for_debit
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       amount: "123",
       purchaseOrderNo: "INV-123",
       bsbNumber: "1234",
       accountNumber:  "56789",
       accountName: "John Smith",
       creditFlag: "No"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <AddPaymentResponse xmlns="https://px.securepay.com.au/">
        <AddPaymentResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
            <Data>S</Data>
            <Error>0</Error>
            <ErrorMessage i:nil="true"/>
        </AddPaymentResult>
        </AddPaymentResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://test.securepay.com.au/xmlapi/directentry/").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.add_one_time_payment('debit', payment_options)
    puts "#######################"
    puts "response #{response}"
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

  def test_add_periodic_payment
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       clientID: "xx123",
       amount: "123",
       startDate: "20040107",
       numberOfPayments: "12",
       bsbNumber: "1234",
       accountNumber:  "56789",
       accountName: "John Smith",
       creditFlag: "No"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <AddPaymentResponse xmlns="https://px.securepay.com.au/">
        <AddPaymentResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
            <Data>S</Data>
            <Error>0</Error>
            <ErrorMessage i:nil="true"/>
        </AddPaymentResult>
        </AddPaymentResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://test.securepay.com.au/xmlapi/directentry/").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.add_periodic_payment(payment_options)
    puts "#######################"
    puts "response #{response}"
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

end