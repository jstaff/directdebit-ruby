require File.expand_path('../../test_helper', __FILE__)

class CustomerTest < Minitest::Unit::TestCase

  DirectDebit.logger.level = Logger::DEBUG
  DirectDebit::Ezidebit.api_base="https://api.demo.ezidebit.com.au/"
  DirectDebit::Ezidebit.api_version="v3-3"
  DirectDebit::Ezidebit.api_digital_key='89FCA516-6C43-428F-A2E8-729ABF7CB9BE'

  def test_add_customer
    customer = DirectDebit::Ezidebit::Customer.new

    customer_options = {
        YourSystemReference: "24412",
        YourGeneralReference: "24412",
        LastName: "Last Name 2",
        FirstName: "First Name 2",
        AddressLine1: "Address Line 12",
        AddressLine2: "Address Line 22",
        AddressSuburb: "Sub2",
        AddressState: "QLD",
        AddressPostCode: "4051",
        EmailAddress: "test2422@myproperty.com",
        MobilePhoneNumber: "0400123456",
        ContractStartDate: "2014-08-10",
        SmsPaymentReminder: "NO",
        SmsFailedNotification: "NO",
        SmsExpiredCard: "NO",
        Username: "WebServiceUser"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <AddCustomerResponse xmlns="https://px.ezidebit.com.au/">
        <AddCustomerResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
            <Data xmlns:a="http://schemas.datacontract.org/2004/07/Ezidebit.PaymentExchange.V3_3.DataContracts">
            <a:CustomerRef>123456</a:CustomerRef>
            </Data>
            <Error>0</Error>
            <ErrorMessage i:nil="true"/>
        </AddCustomerResult>
        </AddCustomerResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.add_customer(customer_options)
    assert_equal("123456", response[:CustomerRef])
  end

  def test_edit_customer
    customer = DirectDebit::Ezidebit::Customer.new

    customer_options = {
       EziDebitCustomerID: "",
       YourSystemReference: "24411",
       NewYourSystemReference: "",
       YourGeneralReference: "18000",
       LastName: "Last Name 2",
       FirstName: "First Name 2",
       AddressLine1: "Address Line 1",
       AddressLine2: "Address Line 2",
       AddressSuburb: "Wiltston",
       AddressState: "QLD",
       AddressPostCode: "4051",
       EmailAddress: "test2422@myproperty.com",
       MobilePhoneNumber: "0400123456",
       SmsPaymentReminder: "NO",
       SmsFailedNotification: "NO",
       SmsExpiredCard: "NO",
       Username: "WebServiceUser"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <EditCustomerDetailsResponse xmlns="https://px.ezidebit.com.au/">
        <EditCustomerDetailsResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data>S</Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </EditCustomerDetailsResult>
        </EditCustomerDetailsResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.edit_customer(customer_options)
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

  def test_get_customer_details
    customer = DirectDebit::Ezidebit::Customer.new

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <GetCustomerDetailsResponse xmlns="https://px.ezidebit.com.au/">
        <GetCustomerDetailsResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data>
            <AddressLine1>123 JONES ST</AddressLine1>
            <AddressLine2>LEVEL 2</AddressLine2>
            <AddressPostCode>4051</AddressPostCode>
            <AddressState>QLD</AddressState>
            <AddressSuburb>WILSTON</AddressSuburb>
            <ContractStartDate>2011 03 01T00:00:00</ContractStartDate>
            <CustomerFirstName>JOHN</CustomerFirstName>
            <CustomerName>STEVENS</CustomerName>
            <Email>jstevens@example.com</Email>
            <EziDebitCustomerID>352818</EziDebitCustomerID>
            <MobilePhone>0400000000</MobilePhone>
            <PaymentMethod>DR</PaymentMethod>
            <PaymentPeriod>W</PaymentPeriod>
            <PaymentPeriodDayOfMonth>5</PaymentPeriodDayOfMonth>
            <PaymentPeriodDayOfWeek>MON</PaymentPeriodDayOfWeek>
            <SmsExpiredCard>NO</SmsExpiredCard>
            <SmsFailedNotification>NO</SmsFailedNotification>
            <SmsPaymentReminder>NO</SmsPaymentReminder>
            <StatusCode>A</StatusCode>
            <StatusDescription>Active</StatusDescription>
            <TotalPaymentsFailed>0</TotalPaymentsFailed>
            <TotalPaymentsFailedAmount>0</TotalPaymentsFailedAmount>
            <TotalPaymentsSuccessful>0</TotalPaymentsSuccessful>
            <TotalPaymentsSuccessfulAmount>0</TotalPaymentsSuccessfulAmount>
            <YourGeneralReference>102</YourGeneralReference>
            <YourSystemReference>102</YourSystemReference>
￼￼      </Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </GetCustomerDetailsResult>
        </GetCustomerDetailsResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.get_customer_details("352818")
    puts "rsponse: #{response}"
    expected = {"AddressLine1"=>"123 JONES ST", 
                "AddressLine2"=>"LEVEL 2",
                "AddressPostCode"=>"4051",
                "AddressState"=>"QLD",
                "AddressSuburb"=>"WILSTON",
                "ContractStartDate"=>"2011 03 01T00:00:00",
                "CustomerFirstName"=>"JOHN",
                "CustomerName"=>"STEVENS",
                "Email"=>"jstevens@example.com",
                "EziDebitCustomerID"=>"352818",
                "MobilePhone"=>"0400000000",
                "PaymentMethod"=>"DR",
                "PaymentPeriod"=>"W",
                "PaymentPeriodDayOfMonth"=>"5",
                "PaymentPeriodDayOfWeek"=>"MON",
                "SmsExpiredCard"=>"NO",
                "SmsFailedNotification"=>"NO",
                "SmsPaymentReminder"=>"NO",
                "StatusCode"=>"A",
                "StatusDescription"=>"Active",
                "TotalPaymentsFailed"=>"0",
                "TotalPaymentsFailedAmount"=>"0",
                "TotalPaymentsSuccessful"=>"0",
                "TotalPaymentsSuccessfulAmount"=>"0",
                "YourGeneralReference"=>"102",
                "YourSystemReference"=>"102"}
    assert_equal(expected, response)
  end

  def test_change_customer_status
    customer = DirectDebit::Ezidebit::Customer.new


    customer_options = {
        EziDebitCustomerID: "",
        YourSystemReference: "243",
        NewStatus: "A",
        Username: "WebServiceUser"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <ChangeCustomerStatusResponse xmlns="https://px.ezidebit.com.au/">
        <ChangeCustomerStatusResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data>S</Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </ChangeCustomerStatusResult>
        </ChangeCustomerStatusResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.change_customer_status(customer_options)
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

  def test_edit_bank_account
    customer = DirectDebit::Ezidebit::Customer.new

    customer_options = {
        EziDebitCustomerID: "",
        YourSystemReference: "240",
        BankAccountName: "Joe Smith",
        BankAccountBSB: "064001",
        BankAccountNumber: "1234",
        Reactivate: "YES",
        Username: "WebServiceUser"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <EditCustomerBankAccountResponse xmlns="https://px.ezidebit.com.au/">
        <EditCustomerBankAccountResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data>S</Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </EditCustomerBankAccountResult>
        </EditCustomerBankAccountResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/pci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.edit_bank_account(customer_options)
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

  def test_create_schedule
    customer = DirectDebit::Ezidebit::Customer.new

    customer_options = {
        EziDebitCustomerID: "",
        YourSystemReference: "18",
        ScheduleStartDate: "2014-08-10",
        SchedulePeriodType: "M",
        DayOfWeek: "",
        DayOfMonth: "1",
        FirstWeekOfMonth: "",
        SecondWeekOfMonth: "",
        ThirdWeekOfMonth: "",
        FouthWeekOfMonth: "",
        PaymentAmountInCents: "2000",
        LimitToNumberOfPayments: "12",
        LimitToTotalAmountInCents: "0",
        KeepManualPayments: "YES",
        Username: "WebServiceUser"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <CreateScheduleResponse xmlns="https://px.ezidebit.com.au/">
        <CreateScheduleResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data>S</Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </CreateScheduleResult>
        </CreateScheduleResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/nonpci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.create_schedule(customer_options)
    assert_equal({:Status=>"S", :Error=>"0", :ErrorMessage=>""}, response)
  end

  def test_add_bank_debit
    customer = DirectDebit::Ezidebit::Customer.new

    customer_options = {
        YourSystemReference: "18",
        YourGeneralReference: "",
        NewYourSystemReference: "",
        LastName: "Test Last Name",
        FirstName: "Test First Name",
        EmailAddress: "test241@myproperty.com",
        MobilePhoneNumber: "0400123456",
        PaymentReference: "1",
        BankAccountName: "Joe Smith",
        BankAccountBSB: "064001",
        BankAccountNumber: "1234",
        PaymentAmountInCents: "2000",
        DebitDate: "2014-08-20",
        msPaymentReminder: "NO",
        SmsFailedNotification: "NO",
        SmsExpiredCard: "NO",
        Username: "WebServiceUser"
    }

    response_body=<<-eos
<s:Envelope xmlns:s="http://schemas.xmlsoap.org/soap/envelope/">
    <s:Body>
        <AddBankDebitResponse xmlns="https://px.ezidebit.com.au/">
        <AddBankDebitResult xmlns:i="http://www.w3.org/2001/XMLSchema instance">
        <Data xmlns:a="http://schemas.datacontract.org/2004/07/Ezidebit.PaymentExchange.V3_3.DataContracts">
            <a:CustomerRef>123456</a:CustomerRef>
        </Data>
        <Error>0</Error>
        <ErrorMessage i:nil="true"/>
        </AddBankDebitResult>
        </AddBankDebitResponse>
    </s:Body>
</s:Envelope>
eos
    #TODO: stub the response here
    stub_request(:post, "https://api.demo.ezidebit.com.au/v3-3/pci").
        to_return(:body => response_body, :status => 200, :headers => { 'Content-Length' => 3 })

    response = customer.add_bank_debit(customer_options)
    assert_equal({:CustomerRef=>"123456"}, response)
  end

end
