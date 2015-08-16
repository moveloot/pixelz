module Pixelz
  class ModificationFulfillmentsController < Pixelz::ApplicationController
    def create
      modification_request = ModificationRequest
        .find_by(pixelz_ticket: params[:imageTicket])
      modification_request.update(
        processed_image_url: params[:processedImageURL],
        pixelz_template_id: params[:templateId], fulfilled_at: Time.now
      )
      head :ok
    end
  end
end
