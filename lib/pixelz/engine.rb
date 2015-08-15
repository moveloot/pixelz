module Pixelz
  class Engine < ::Rails::Engine
    isolate_namespace Pixelz
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end

    # Settings

    class << self
      attr_accessor :api_key
    end

    def self.setup(&block)
      yield self
    end
  end
end
