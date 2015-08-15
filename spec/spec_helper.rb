# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'database_cleaner'
require 'sidekiq/testing'
require 'webmock/rspec'
require 'pixelz/fake_pixelz_api'
ENGINE_RAILS_ROOT=File.join(File.dirname(__FILE__), '../')
Dir[File.join(ENGINE_RAILS_ROOT, "spec/support/**/*.rb")].each {|f| require f }
Dir[File.join(ENGINE_RAILS_ROOT, "spec/factories/*.rb")].each {|f| require f }
# AFAIK We can't maintain schema via migration in engines.
# ActiveRecord::Migration.maintain_test_schema!
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.include Support::ResponseHelpers
  config.include FactoryGirl::Syntax::Methods
  config.use_transactional_fixtures = false
  config.infer_base_class_for_anonymous_controllers = false
  config.infer_spec_type_from_file_location!
  Kernel.srand config.seed
  config.order = "random"
  config.default_formatter = 'doc' if config.files_to_run.one?
  config.mock_with :rspec do |mocks|
    mocks.syntax = :expect
    mocks.verify_partial_doubles = true
  end
  config.fail_fast = true
  config.filter_run :focus
  config.run_all_when_everything_filtered = true

  config.before(:suite) do
    DatabaseCleaner.clean_with :truncation
  end
  config.before do
    stub_request(:any, /api.pixelz.com/).to_rack(FakePixelzApi)
    DatabaseCleaner.strategy = :transaction
  end
  config.before(:each, js: true) do
    DatabaseCleaner.strategy = :truncation
  end
  config.before do
    DatabaseCleaner.start
  end
  config.after(:each) do
    DatabaseCleaner.clean
  end
end
