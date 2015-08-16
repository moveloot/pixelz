Pixelz.setup do |config|
  config.processed_image_callback = 'save_processed_version'
  config.api_key = "test_key"
  config.pixelz_account_email = "test@example.com"
  config.mount_uri = "https://test.com/pixelz"
  config.public_url_getter = "url"
  # config.product_identifier = 'product_id' # optional
end
