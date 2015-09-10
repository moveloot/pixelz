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

      def reject(image_ticket, comment='')
        res = RestClient.put(
                BASE_URI + "/Image/Reject/#{image_ticket}", 
                reject_image_payload(comment), 
                headers
              )
        Hash.from_xml(res)
      end

      private

      def headers
        { 'Content-Type' => 'application/json; charset=UTF-8' }
      end

      def default_payload
        {
          contactEmail: Pixelz.pixelz_account_email,
          contactAPIkey: Pixelz.api_key
        }
      end

      def image_payload
        payload = {
          imageURL: @image.send(Pixelz.public_url_getter),
          imageCallbackURL: Pixelz.mount_uri + '/modification_fulfillments'
        }

        default_payload.merge(payload).tap do |h|
          if Pixelz.product_identifier.present?
            h.merge!(productId: @image.send(Pixelz.product_identifier))
          end
        end.to_json
      end

      def reject_image_payload(comment)
        default_payload.merge({ comment: comment }).to_json      
      end
    end
  end
end
