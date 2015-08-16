describe Pixelz::ModificationFulfillmentsController, type: :request do
  describe 'POST /pixelz/modification_fulfillments' do
    context 'a modification request with a matching ticket exists' do
      before do
        @modification_request =
          create(:modification_request, pixelz_ticket: 'a123')
      end
      it 'marks the request as fulfilled and sets relevant attrs' do
        post '/pixelz/modification_fulfillments', fulfillment_params
        expect(response.status).to eq 200
        @modification_request.reload
        expect(@modification_request.processed_image_url).to match 'processed'
        expect(@modification_request.pixelz_template_id).to match 'sometemp'
        expect(@modification_request.fulfilled_at).not_to be_nil
      end
      it 'calls the post-modification callback on the parent image' do
        image_double = double('Image', save_processed_version: true)
        allow_any_instance_of(Pixelz::ModificationRequest)
          .to receive(:modifiable).and_return image_double
        expect(image_double).to receive(:save_processed_version)
          .with('img.processed')
        post '/pixelz/modification_fulfillments', fulfillment_params
      end
    end

    def fulfillment_params(overrides={})
      {
        imageTicket: overrides[:imageTicket] || 'a123',
        processedImageURL: 'img.processed',
        templateId: 'sometemplate'
      }
    end
  end
end
