module DirectDebit
  class Util

    #Nokogiri::XML::Builder uses method missing to build xml elements, 
    #send will still raise method missing and create elements dynamically
    def self.generate_xml_options(xml, options={})
    end

  end
end