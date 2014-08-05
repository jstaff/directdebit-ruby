Gem::Specification.new do |s|
  s.name        = 'ezidebit'
  s.version     = '0.0.0'
  s.date        = '2014-08-01'
  s.summary     = "Ruby bindins for the Ezidebit API"
  s.description = "Description Here"
  s.authors     = ["Jason Stafford"]
  s.email       = 'jasonstaff17@gmail.com'
  s.homepage    =
    'http://rubygems.org/gems/hola'
  s.license       = 'MIT'

  s.add_dependency "savon",     "~> 2.3.0"

  s.files = `git ls-files`.split("\n")
end