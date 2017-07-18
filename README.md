directdebit-ruby
=============

Direct debit API bindings for Ruby

directdebit-ruby is a ruby client for the Ezidebit and SecurePay Web Services.

### Getting Started

```
gem 'directdebit', :github => 'jstaff/directdebit-ruby', :branch => 'master'
````

## Configuration

```
Ezidebit.api_base="https://api.demo.ezidebit.com.au/"
Ezidebit.api_digital_key='XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX'
```

## Logger
```
Ezidebit.logger.level = Logger::DEBUG
```

##Examples

### Add Ezidebit Customer

```
Ezidebit::Customer.add_customer({
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
   Username: "WebServiceUser"})
```

### Edit Ezidebit Customer

```

Ezidebit::Customer.edit_customer({
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
   Username: "WebServiceUser"})
```
### Change Ezidebit Customer Status

```
Ezidebit::Customer.change_customer_status({
   EziDebitCustomerID: "",
   YourSystemReference: "243",
   NewStatus: "A",
   Username: "WebServiceUser"})
```

### Add Manual Payment To Ezidebit Customer
```
Ezidebit::Payment.add_payment({
   EziDebitCustomerID: "",
   YourSystemReference: "123",
   DebitDate: "2020-01-01",
   PaymentAmountInCents: "2000",
   PaymentReference: "manual payment test",
   Username: "WebServiceUser"})
```

### Add Bank Account to Ezidebit Customer
```
Ezidebit::Customer.edit_bank_account({
   EziDebitCustomerID: "",
   YourSystemReference: "123",
   BankAccountName: "Joe Smith",
   BankAccountBSB: "064001",
   BankAccountNumber: "1234",
   Reactivate: "YES",
   Username: "WebServiceUser"})
```

### Add Payment Schedule to Ezidebit Customer
```
Ezidebit::Customer.create_schedule({
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
   Username: "WebServiceUser"})
```

### Add Bank Debit to Ezidebit Customer
```
Ezidebit::Customer.add_bank_debit({
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
   Username: "WebServiceUser"})
```
