ezidebit-ruby
=============

Ezidebit API bindings for Ruby

Ezidebit-ruby is a ruby client for the Ezidebit Web Services SOAP API.

### Getting Started

gem 'ezidebit', :github => 'jstaff/ezidebit-ruby', :branch => 'master'

## Setup

```
Ezidebit.api_base="https://api.demo.ezidebit.com.au/"
Ezidebit.api_digital_key='XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'
```

## Logger
```
Ezidebit.logger.level = Logger::DEBUG
```

##Supported Actions

### Add Ezidebit Customer

```
customer = {
   YourSystemReference: "123",
   YourGeneralReference: "1234",
   LastName: "Last Name",
   FirstName: "First Name",
   AddressLine1: "Address Line 12",
   AddressLine2: "Address Line 2",
   AddressSuburb: "Sub",
   AddressState: "QLD",
   AddressPostCode: "4051",
   EmailAddress: "customer@example.com",
   MobilePhoneNumber: "0400123456",
   ContractStartDate: "2014-08-10",
   SmsPaymentReminder: "NO",
   SmsFailedNotification: "NO",
   SmsExpiredCard: "NO",
   Username: "WebServiceUser"
}


Ezidebit::Customer.add_customer(customer)
```

### Edit Ezidebit Customer

```
edit_customer = {
   EziDebitCustomerID: "",
   YourSystemReference: "123",
   NewYourSystemReference: "",
   YourGeneralReference: "1234",
   LastName: "Last Name",
   FirstName: "First Name",
   AddressLine1: "Address Line 1",
   AddressLine2: "Address Line 2",
   AddressSuburb: "Wiltston",
   AddressState: "QLD",
   AddressPostCode: "4051",
   EmailAddress: "customer@example.com",
   MobilePhoneNumber: "0400123456",
   SmsPaymentReminder: "NO",
   SmsFailedNotification: "NO",
   SmsExpiredCard: "NO",
   Username: "WebServiceUser"
}

Ezidebit::Customer.edit_customer(edit_customer)
```
### Change Ezidebit Customer Status

```
customer_status = {
   EziDebitCustomerID: "",
   YourSystemReference: "243",
   NewStatus: "A",
   Username: "WebServiceUser"
}

Ezidebit::Customer.change_customer_status(customer_status)
```

### Add Manual Payment To Ezidebit Customer
```
payment = {
   EziDebitCustomerID: "",
   YourSystemReference: "123",
   DebitDate: "2020-01-01",
   PaymentAmountInCents: "2000",
   PaymentReference: "manual payment test",
   Username: "WebServiceUser"
}

Ezidebit::Payment.add_payment(payment)
```

### Add Bank Account to Ezidebit Customer
```
bank_account = {
   EziDebitCustomerID: "",
   YourSystemReference: "123",
   BankAccountName: "Joe Smith",
   BankAccountBSB: "064001",
   BankAccountNumber: "1234",
   Reactivate: "YES",
   Username: "WebServiceUser"
}

Ezidebit::Customer.edit_bank_account(bank_account)
```

### Add Payment Schedule to Ezidebit Customer
```
customer_schedule = {
   EziDebitCustomerID: "",
   YourSystemReference: "123",
   ScheduleStartDate: "2020-01-01",
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

Ezidebit::Customer.create_schedule(customer_schedule)
```

### Add Bank Debit to Ezidebit Customer
```
bank_debit = {
   YourSystemReference: "1234",
   YourGeneralReference: "",
   NewYourSystemReference: "",
   LastName: "Last Name",
   FirstName: "First Name",
   EmailAddress: "test@example.com",
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

Ezidebit::Customer.add_bank_debit(bank_debit)
```
