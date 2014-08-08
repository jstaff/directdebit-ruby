module Ezidebit
  class EzidebitObject
  	
  	def last_request
  		@@last_response
  	end

  	def last_response
  		@@last_response
  	end
	
    def self.construct_envelope(&block)
      Nokogiri::XML::Builder.new do |xml|
        xml.Envelope("xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/",
                    "xmlns:px" => "https://px.ezidebit.com.au/") do
             xml.parent.namespace = xml.parent.namespace_definitions.first
             xml['soapenv'].Header {}
             xml['soapenv'].Body(&block)
          end
      end
    end

    # Performs the SOAP request
    def self.soap_it!(soap_action, &block)
      data = construct_envelope(&block)
      @@last_request = data
      response = Typhoeus::Request.post('https://api.demo.ezidebit.com.au/v3-3/nonpci',
                              :body    => data.to_xml,
                              :headers => {'Content-Type' => "text/xml;charset=UTF-8", 'SOAPAction' => soap_action})

      process_response(response)
    end

    # Processes the response and decides whether to handle an error/fault or
    # whether to return the content
    def self.process_response(response)
      @@last_response = response

      xml = Nokogiri::XML(response.body)

      xml.remove_namespaces!

      if xml.xpath("//Error").text.to_i > 0 
        handle_error(response)
      elsif xml.xpath("//Fault").any? 
        handle_fault(response)
      else
        puts "Response: #{response.inspect}"
        return response
      end
    end

    # Parses a Error and raises it as a Ezidebit::SoapError
    def self.handle_error(response)
      xml   = Nokogiri::XML(response.body)
      xml.remove_namespaces!
      xpath = '//ErrorMessage'
      msg   = xml.xpath(xpath).text

      # TODO: Capture any app-specific exception messages here.
      #       For example, if the server returns a Fault when a search
      #       has no results, you might rather return an empty array.
      raise Ezidebit::SoapError.new("Error from server: #{msg}", @@last_request, @@last_response)
    end

     # Parses a Fault error and raises it as a Ezidebit::SoapError
    def self.handle_fault(response)
      puts "Response: #{response.inspect}"
      xml   = Nokogiri::XML(response.body)
      xml.remove_namespaces!
      xpath = '//faultstring'
      msg   = xml.xpath(xpath).text

      raise Ezidebit::SoapError.new("Fault from server: #{msg}", @@last_request, @@last_response)
    end


  end
end