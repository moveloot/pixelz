require 'rest-client'

module Pixelz
  class Engine < ::Rails::Engine
    isolate_namespace Pixelz
    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, dir: 'spec/factories'
    end
  end

  # Settings

  class << self
    attr_accessor :api_key, :pixelz_account_email, :mount_uri,
      :public_url_getter, :product_identifier, :processed_image_callback,
      :api_secret
  end

  def self.setup(&block)
    yield self
  end

  class Error < StandardError; end

end
