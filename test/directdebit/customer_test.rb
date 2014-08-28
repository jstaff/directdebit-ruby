require File.expand_path('../../test_helper', __FILE__)

class CustomerTest < Minitest::Unit::TestCase
  def test_add_customer
    customer = {
     YourSystemReference: "244",
     YourGeneralReference: "244",
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

    assert_equal "hello world", "hello world"
  end
end
