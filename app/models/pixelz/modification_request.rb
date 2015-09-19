require 'pixelz/api_client/image'

module Pixelz
  class ModificationRequest < ActiveRecord::Base
    belongs_to :modifiable, polymorphic: true
    delegate Pixelz.processed_image_callback, to: :modifiable

    def self.modify(image)
      return unless ModificationRequest.where(
        modifiable_type: image.class.name, modifiable_id: image.id
      ).empty?
      res = Pixelz::ApiClient::Image.new(image).post
      raise_pixelz_error(res, 'AddImageResponse')
      image.modification_requests
        .create(pixelz_ticket: res['AddImageResponse']['ImageTicket'])
    end

    def self.raise_pixelz_error(res, key)
      return if res[key]['ErrorCode'] == 'NoError'
      raise Pixelz::Error.new res[key]['Message']
    end

    def reject(comment)
      api_image = Pixelz::ApiClient::Image.new(modifiable)
      res = api_image.reject(pixelz_ticket, comment)
      # Pixelz::ModificationRequest.raise_pixelz_error(
      #   res,
      #   'RejectImageResponse'
      # )
    end


    def self.test(test)
      test
    end
  end
end
