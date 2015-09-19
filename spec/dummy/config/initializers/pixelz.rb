Pixelz.setup do |config|
  config.processed_image_callback = :save_processed_version
  config.api_key = "e6c426b5-e26d-40cf-acf1-2825479b89e7"
  config.pixelz_account_email = "kirati@tripler.co.th"
  config.mount_uri = "https://test.com/pixelz"
  config.public_url_getter = :url
  # config.product_identifier = 'product_id' # optional
end
