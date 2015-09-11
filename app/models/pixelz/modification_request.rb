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
      res = Pixelz::ApiClient::Image.new(modifiable).reject(pixelz_ticket, comment)
      Pixelz::ModificationRequest.send(:raise_pixelz_error, res, 'RejectImageResponse')
      res
    end
    
    private_class_method :raise_pixelz_error
  end
end
