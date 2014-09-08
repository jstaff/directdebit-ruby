module DirectDebit
  class ApiObject

    attr_accessor :request
    attr_reader :end_point

    @@last_request = ""
    @@last_response = ""

    def initialize
      @end_point =  self.class.api_url
      @request =  Typhoeus::Request.new("")
    end

  	def last_response
  		@@last_response
  	end

    def self.xml_type
      raise "This must be defined in implementing type of ApiObject"
    end
	
    def self.construct_soap_envelope(&block)
      Nokogiri::XML::Builder.new do |xml|
        xml.Envelope("xmlns:soapenv" => "http://schemas.xmlsoap.org/soap/envelope/") do
             xml.parent.namespace = xml.parent.namespace_definitions.first
             xml['soapenv'].Header {}
             xml['soapenv'].Body(&block)
          end
      end
    end

    def self.construct_xml(type, &block)
      if type == "soap"
        return construct_soap_envelope(&block)
      else
        Nokogiri::XML::Builder.new &block
      end
    end

    def self.api_url(url='')
        raise "This api_url class method be defined in implementing type of ApiObject"
    end


    def end_point=(endpoint = "")
      @end_point = self.class.api_url endpoint 
    end

    def create_request(end_point = "", soap_action = "", &block)
      data = self.class.construct_xml(self.class.xml_type, &block)
      self.end_point = end_point
      DirectDebit.logger.debug "###############################################"
      DirectDebit.logger.debug "XML Message: #{data.to_xml}"
      DirectDebit.logger.debug "End Point: #{self.end_point}"
      request = self.request = Typhoeus::Request.new(self.end_point,
        :method  => :post,
        :body    => data.to_xml,
        :headers => {'Content-Type' => "text/xml;charset=UTF-8", 'SOAPAction' => soap_action})
    end


    # Performs soap request
    def request_it!
      response = @request.run
      self.class.process_response(response)
    end

    # Processes the response and decides whether to handle an error/fault or
    # whether to return the content
    #TODO: passing error matchers to generlize
    def self.process_response(response)
      @@last_response = response

      xml = Nokogiri::XML(response.body)

      DirectDebit.logger.debug "Response: #{xml.to_xml}"

      xml.remove_namespaces!

      if xml.xpath("//Error").text.to_i > 0 
        handle_error(response, '//ErrorMessage')
      elsif xml.xpath("//Fault").any? 
        handle_fault(response, '//faultstring')
      elsif xml.xpath('//responseCode').text.to_i > 0
        handle_error(response, '//responseText')
      else
        return response
      end
    end

    # Parses a Error and raises it as a DirectDebit::SoapError
    def self.handle_error(response, xpath)
      xml   = Nokogiri::XML(response.body)
      xml.remove_namespaces!
      msg   = xml.xpath(xpath).text

      # TODO: Capture any app-specific exception messages here.
      #       For example, if the server returns a Fault when a search
      #       has no results, you might rather return an empty array.
      raise DirectDebit::SoapError.new("Error from server: #{msg}", @@last_request, @@last_response)
    end

     # Parses a Fault error and raises it as a DirectDebit::SoapError
    def self.handle_fault(response, xpath)
      xml   = Nokogiri::XML(response.body)
      xml.remove_namespaces!
      msg   = xml.xpath(xpath).text

      raise DirectDebit::SoapError.new("Fault from server: #{msg}", @@last_request, @@last_response)
    end
  end
end