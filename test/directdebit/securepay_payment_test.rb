require File.expand_path('../../test_helper', __FILE__)

class CustomerTest < Minitest::Unit::TestCase

  DirectDebit.logger.level = Logger::DEBUG
  DirectDebit::Securepay.api_base="https://test.securepay.com.au/xmlapi/directentry/"
  DirectDebit::Securepay.api_version="v3-3"
  DirectDebit::Securepay.api_merchant_id='ABC0001'
  DirectDebit::Securepay.api_merchant_passwd='changit'

  def test_add_payment
    payment = DirectDebit::Securepay::Payment.new

    payment_options = {
       EziDebitCustomerID: "",
       YourSystemReference: "240",
       DebitDate: "2014-08-10",
       PaymentAmountInCents: "2000",
       PaymentReference: "test",
       Username: "WebServiceUser"
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
    stub_request(:post, "https://test.securepay.com.au/xmlapi/directentry/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.add_payment(payment_options)
    puts "#######################"
    puts "response #{response}"
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

end