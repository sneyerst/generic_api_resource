$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "generic_api_resource/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "generic_api_resource"
  s.version     = GenericApiResource::VERSION
  s.authors     = ["Tom Sneyers"]
  s.email       = ["tom@sneyers-consultancy.be"]
  s.homepage    = "https://github.com/sneyerst/generic_api_resource"
  s.summary     = "A thin abstraction layer for writing API's in Rails."
  s.description = "A thin abstraction layer for writing API's in Rails. "
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "> 4.2"

  s.add_development_dependency "sqlite3"
end
