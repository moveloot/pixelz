describe Pixelz::ModificationRequest do
  describe '::modify' do
    before { @image = create(:image) }
    context 'all parameters provided' do
      it 'saves and returns a new modification request' do
        modification_request = Pixelz::ModificationRequest.modify(@image)
        expect(modification_request.pixelz_ticket)
          .to eq 'a37a1f55-7cd4-4474-db19-ac03e85538a7'
        expect(@image.modification_requests).to include modification_request
      end
      context 'a modification already exists' do
        before { @image.modification_requests.create }
        it 'does not send a second request or create another modification' do
          allow(Pixelz::ApiClient::Image).to receive(:new)
          Pixelz::ModificationRequest.modify(@image)
          expect(Pixelz::ApiClient::Image).not_to have_received(:new)
          expect(@image.modification_requests(true).count).to eq 1
        end
      end
    end
    context 'something causes Pixelz API error (e.g. missing param)' do
      it 'returns an informative error' do
        @image.url = nil
        expect { Pixelz::ModificationRequest.modify(@image) }
          .to raise_error(Pixelz::Error, /missing/)
      end
    end
    context 'a product identifier is provided' do
      it 'includes the product id with the request to pixelz' do
        Pixelz.product_identifier = :product_id
        allow_any_instance_of(Image).to receive(:product_id)
          .and_return('great_chair')
        success_xml = File.open(
          File.dirname(__FILE__) +
          '/../../fixtures/fake_pixelz_api_responses/image_post.xml', 'rb'
        ).read
        allow(RestClient).to receive(:post).and_return(success_xml)
        Pixelz::ModificationRequest.modify(@image)
        expect(RestClient).to have_received(:post)
          .with('https://api.pixelz.com/REST.svc/Image/', {
          contactEmail: 'test@example.com', contactAPIkey: 'test_key',
          imageURL: @image.url,
          imageCallbackURL: 'https://test.com/pixelz/modification_fulfillments',
          productId: 'great_chair'
        }.to_json, { 'Content-Type' => 'application/json; charset=UTF-8' })
      end
    end
  end
end
