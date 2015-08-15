require 'sinatra/base'
require 'json'
require 'active_support'
require 'active_support/core_ext/object/blank'

class FakePixelzApi < Sinatra::Base
  set :port, 4999

  before do
    body = request.body.read
    @params = JSON.parse(body) if body.present?
  end

  post '/REST.svc/Image' do
    if valid_image_post?
      xml_response 200, 'image_post.xml'
    else
      xml_response 200, 'image_post_error.xml'
    end
  end

  private

  def valid_image_post?
    @params['contactEmail'].present? && @params['contactAPIkey'].present? &&
      @params['imageURL'].present? && @params['imageCallbackURL'].present?
  end

  def xml_response(response_code, file_name)
    content_type :xml
    status response_code
    File.open(
      File.dirname(__FILE__) + '/fixtures/fake_pixelz_api_responses' +
      file_name, 'rb'
    ).read
  end
end
