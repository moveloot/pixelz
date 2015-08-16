module Pixelz
  class ModificationFulfillmentsController < Pixelz::ApplicationController
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
  end
end
