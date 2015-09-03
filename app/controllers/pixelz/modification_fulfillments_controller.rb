require 'base64'
require 'openssl'

module Pixelz
  class ModificationFulfillmentsController < Pixelz::ApplicationController
    
    before_action :verify_webhook, only: :create

    def create
      set_modification_request
      update_modification_request
      call_modifiable_callback_with_processed_param
      head :ok
    end

    private

    def set_modification_request
      @modification_request = ModificationRequest
        .find_by(pixelz_ticket: params[:imageTicket])
    end

    def update_modification_request
      @modification_request.update(
        processed_image_url: params[:processedImageURL],
        pixelz_template_id: params[:templateId], fulfilled_at: Time.now
      )
    end

    def call_modifiable_callback_with_processed_param
      @modification_request.send(
        Pixelz.processed_image_callback,
        @modification_request.processed_image_url
      )
    end

    def verify_webhook
      request.body.rewind
      hmac_header = request.headers['Http-X-Rtb-Partner-Hmac-Sha256']
      digest = OpenSSL::Digest.new('sha256')
      data = request.body.read.to_s
      sha = OpenSSL::HMAC.digest(digest, Pixelz.api_secret, data)
      calculated_hmac = Base64.encode64(sha).strip

      p "Logging: Start"
      p "HTTP Partner: " + hmac_header
      p "End result: " + calculated_hmac
      p "data: " + data
      p "Logging: End"
      # binding.pry

      unless calculated_hmac == hmac_header
        head :unauthorized
      end
      request.body.rewind
    end
  end
end
