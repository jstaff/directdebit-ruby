$:.unshift(File.join(File.dirname(__FILE__), 'lib'))

require 'ezidebit/version'

Gem::Specification.new do |s|
  s.name        = 'directdebit'
  s.version     = Ezidebit::VERSION
  s.date        = '2014-08-27'
  s.summary     = "Ruby bindings for the Ezidebit and Securepay APIs"
  s.description = "Ruyb Gem for consuming direct debit payment APIs "
  s.authors     = ["Jason Stafford"]
  s.email       = 'jasonstaff17@gmail.com'
  s.homepage    = 'https://github.com/jstaff/ezidebit-ruby/'
  s.license     = 'MIT'

  s.add_dependency "logger"
  s.add_dependency "nokogiri"
  s.add_dependency "typhoeus"
  s.add_development_dependency('minitest')
  s.add_development_dependency('mocha')
  s.add_development_dependency('rake')

  s.files = `git ls-files`.split("\n")
end