$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pixelz/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pixelz"
  s.version     = Pixelz::VERSION
  s.authors     = ["Move Loot Inc.", "Lockstep Labs"]
  s.email       = ["paul@locksteplabs.com"]
  s.homepage    = "http://www.moveloot.com"
  s.summary     = "An easy interface for the Pixelz background removal service."
  s.description = "Pixelz is an image processing service."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.add_dependency "rails", "~> 4.1.9"
  s.add_dependency "sidekiq", '~> 3.3.0'
  s.add_dependency "rest-client", '~> 1.8.0'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "database_cleaner", '~> 1.4.1'
  s.add_development_dependency "rspec-rails", '~> 3.3.2'
  s.add_development_dependency "spring", '~> 1.3.6'
  s.add_development_dependency "spring-commands-rspec", '~> 1.0.4'
  s.add_development_dependency "factory_girl_rails", '~> 4.5'
  s.add_development_dependency "webmock", '~> 1.21.0'
  s.add_development_dependency "sinatra"
end
