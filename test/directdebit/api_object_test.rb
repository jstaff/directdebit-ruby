require File.expand_path('../../test_helper', __FILE__)

class ApiObjectTest < Minitest::Unit::TestCase
  def test_xml_type
    proc   { DirectDebit::ApiObject.xml_type }.must_raise RuntimeError
  end

  def test_construct_xml_with_xml_returns_builder
    builder  = DirectDebit::ApiObject.construct_xml("xml") {}
    assert builder.instance_of?(Nokogiri::XML::Builder) 
  end

  def test_construct_xml_with_xmlsoap_returns_builder
    builder  = DirectDebit::ApiObject.construct_xml("soapxml") {}
    assert builder.instance_of?(Nokogiri::XML::Builder) 
  end

  def test_construct_soap_envelope
    builder = DirectDebit::ApiObject.construct_soap_envelope {}
    xml = Nokogiri::XML::parse(builder.to_xml)
    match = xml.at_xpath('.//ns:Envelope', { ns: 'http://schemas.xmlsoap.org/soap/envelope/'})
    assert match != nil, "Could not find Envelope" 
  end

  def test_api_url
    proc  { DirectDebit::ApiObject.api_url('test')  }.must_raise RuntimeError
  end

  def test_end_point
    api_base = "https://api.demo.ezidebit.com.au/"
    api_version = "v3-3"
    DirectDebit::Ezidebit::api_base=api_base
    DirectDebit::Ezidebit::api_version=api_version
    ezidebit_object = DirectDebit::Ezidebit::EzidebitObject.new
    ezidebit_object.end_point="endpoint"
    expected_end_point = api_base+api_version+"/"+"endpoint"
    assert_equal(ezidebit_object.end_point, expected_end_point)
  end

  def test_request_it!
    assert true
  end

  def test_process_response
  end

  def test_handle_error
  end

  def test_handle_fault
  end

end