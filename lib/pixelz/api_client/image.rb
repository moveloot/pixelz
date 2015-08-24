module Pixelz
  module ApiClient
    class Image
      BASE_URI = 'https://api.pixelz.com/REST.svc'

      def initialize(image)
        @image = image
      end

      def post
        res = RestClient.post(BASE_URI + "/Image/", image_payload, headers)
        Hash.from_xml(res)
      end

      private

      def headers
        { 'Content-Type' => 'application/json; charset=UTF-8' }
      end

      def image_payload
        {
          contactEmail: Pixelz.pixelz_account_email,
          contactAPIkey: Pixelz.api_key,
          imageURL: @image.send(Pixelz.public_url_getter),
          imageCallbackURL: Pixelz.mount_uri + '/modification_fulfillments'
        }.tap do |h|
          if Pixelz.product_identifier.present?
            h.merge!(productId: @image.send(Pixelz.product_identifier))
          end
        end.to_json
      end
    end
  end
end
