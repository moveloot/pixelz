require 'pixelz/api_client/image'

module Pixelz
  class ModificationRequest < ActiveRecord::Base
    belongs_to :modifiable, polymorphic: true

    def self.modify(image)
      res = Pixelz::ApiClient::Image.new(image).post
      raise_pixelz_error(res)
      image.modification_requests
        .create(pixelz_ticket: res['AddImageResponse']['ImageTicket'])
    end

    def self.raise_pixelz_error(res)
      return if res['AddImageResponse']['ErrorCode'] == 'NoError'
      raise Pixelz::Error.new res['AddImageResponse']['Message']
    end
    private_class_method :raise_pixelz_error

  end
end
