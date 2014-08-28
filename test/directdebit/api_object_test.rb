require File.expand_path('../../test_helper', __FILE__)

class ApiObjectTest < Minitest::Unit::TestCase
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


end