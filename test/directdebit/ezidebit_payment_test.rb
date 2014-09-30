require File.expand_path('../../test_helper', __FILE__)

class CustomerTest < Minitest::Unit::TestCase

  DirectDebit.logger.level = Logger::DEBUG
  DirectDebit::Ezidebit.api_base="https://api.demo.ezidebit.com.au/"
  DirectDebit::Ezidebit.api_version="v3-3"
  DirectDebit::Ezidebit.api_digital_key='XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'

  def test_add_payment
    payment = DirectDebit::Ezidebit::Payment.new

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
        <AddPaymentResponse xmlns="https://px.ezidebit.com.au/">
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
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.add_payment(payment_options)
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

  def test_get_payment_detail
    payment = DirectDebit::Ezidebit::Payment.new

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
        <GetPaymentDetailsResponse xmlns="https://px.ezidebit.com.au/">
        <GetPaymentDetailsResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data>
            <BankFailedReason/>
            <BankReturnCode>0</BankReturnCode>
            <DebitDate>2011 03 14T00:00:00</DebitDate>
            <InvoiceID/>
            <PaymentAmount>40</PaymentAmount>
            <PaymentID>SCHEDULED12554</PaymentID>
            <PaymentMethod>DR</PaymentMethod>
            <PaymentReference>1</PaymentReference>
            <PaymentStatus>P</PaymentStatus>
            <SettlementDate i:nil="true"/>
            <ScheduledAmount>40.00</ScheduledAmount>
            <TransactionFeeClient>0</TransactionFeeClient>
            <TransactionFeeCustomer>1.35</TransactionFeeCustomer>
            <YourGeneralReference>102</YourGeneralReference>
            <YourSystemReference>102</YourSystemReference>
        </Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </GetPaymentDetailsResult>
        </GetPaymentDetailsResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.get_payment_detail(payment_options)
    expected_values={"BankFailedReason"=>"", 
        "BankReturnCode"=>"0", 
        "DebitDate"=>"2011 03 14T00:00:00", 
        "InvoiceID"=>"", 
        "PaymentAmount"=>"40", 
        "PaymentI"=>"", 
        "PaymentMethod"=>"DR", 
        "PaymentReference"=>"1", 
        "PaymentStatus"=>"P", 
        "SettlementDate"=>"", 
        "ScheduledAmount"=>"40.00", 
        "TransactionFeeClient"=>"0", 
        "TransactionFeeCustomer"=>"1.35", 
        "YourSystemReference"=>"102"}

    assert_equal(expected_values, response)
  end

  def test_get_payments
    payment = DirectDebit::Ezidebit::Payment.new

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <GetPaymentsResponse xmlns="https://px.ezidebit.com.au/">
            <GetPaymentsResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
                <Data>
                    <Payment>
                        <BankFailedReason/>
                        <BankReceiptID>430357</BankReceiptID>
                        <BankReturnCode>O</BankReturnCode>
                        <CustomerName>Test</CustomerName>
                        <DebitDate>2011 01 04T00:00:00</DebitDate>
                        <EziDebitCustomerID/>
                        <InvoiceID>0</InvoiceID>
                        <PaymentAmount>20</PaymentAmount>
                        <PaymentID>WEB48992</PaymentID>
                        <PaymentMethod>CR</PaymentMethod>
                        <PaymentReference>45</PaymentReference>
                        <PaymentSource>WEB</PaymentSource>
                        <PaymentStatus>P</PaymentStatus>
                        <SettlementDate i:nil="true"/>
                        <ScheduledAmount>19.10</ScheduledAmount>
                        <TransactionFeeClient>0.99</TransactionFeeClient>
                        <TransactionFeeCustomer>0</TransactionFeeCustomer>
                        <TransactionTime>2011 01 19T11:45:00</TransactionTime>
                        <YourGeneralReference/>
                        <YourSystemReference/>
                    </Payment>
                    <Payment>
                        <BankFailedReason/>
                        <BankReceiptID>430358</BankReceiptID>
                        <BankReturnCode>O</BankReturnCode>
                        <CustomerName>Test</CustomerName>
                        <DebitDate>2011 02 04T00:00:00</DebitDate>
                        <EziDebitCustomerID/>
                        <InvoiceID>1</InvoiceID>
                        <PaymentAmount>20</PaymentAmount>
                        <PaymentID>WEB48993</PaymentID>
                        <PaymentMethod>CR</PaymentMethod>
                        <PaymentReference>46</PaymentReference>
                        <PaymentSource>WEB</PaymentSource>
                        <PaymentStatus>P</PaymentStatus>
                        <SettlementDate i:nil="true"/>
                        <ScheduledAmount>19.11</ScheduledAmount>
                        <TransactionFeeClient>1.99</TransactionFeeClient>
                        <TransactionFeeCustomer>0</TransactionFeeCustomer>
                        <TransactionTime>2011 01 19T12:45:00</TransactionTime>
                        <YourGeneralReference/>
                        <YourSystemReference/>
                    <Payment>
                </Data>
            <Error>0</Error>
            <ErrorMessage i:nil="true"/>
            </GetPaymentsResult>
        </GetPaymentsResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })


    response = payment.get_payments()
    assert_equal(2, response.count)
  end

end
