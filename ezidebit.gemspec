$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'ezidebit/version'

Gem::Specification.new do |s|
  s.name        = 'ezidebit'
  s.version     = Ezidebit::VERSION
  s.date        = '2014-08-01'
  s.summary     = "Ruby bindings for the Ezidebit API"
  s.description = "Ruyb Gem for Using the EZidebit SOAP Web Services API"
  s.authors     = ["Jason Stafford"]
  s.email       = 'jasonstaff17@gmail.com'
  s.homepage    = 'https://github.com/jstaff/ezidebit-ruby/'
  s.license     = 'MIT'

  s.add_dependency "savon",     "~> 2.3.0"
  s.add_dependency "nokogiri"
  s.add_dependency "typhoeus"

  s.files = `git ls-files`.split("\n")
end