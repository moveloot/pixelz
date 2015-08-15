$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pixelz/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pixelz"
  s.version     = Pixelz::VERSION
  s.authors     = ["Paul Hiatt"]
  s.email       = ["hiattp@gmail.com"]
  s.homepage    = "TODO"
  s.summary     = "TODO: Summary of Pixelz."
  s.description = "TODO: Description of Pixelz."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 4.2.2"

  s.add_development_dependency "sqlite3"
end