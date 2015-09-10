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
      raise_pixelz_error(res)
      image.modification_requests
        .create(pixelz_ticket: res['AddImageResponse']['ImageTicket'])
    end

    def self.raise_pixelz_error(res)
      return if res['AddImageResponse']['ErrorCode'] == 'NoError'
      raise Pixelz::Error.new res['AddImageResponse']['Message']
    end

    def reject(comment)
      res = Pixelz::ApiClient::Image.new(modifiable).reject(pixelz_ticket, comment)
      raise_reject_pixelz_error(res)
      res
    end
    
    private_class_method :raise_pixelz_error

    private

    def raise_reject_pixelz_error(res)
      return if res['RejectImageResponse']['ErrorCode'] == 'NoError'
      raise Pixelz::Error.new res['RejectImageResponse']['Message']
    end
  end
end
