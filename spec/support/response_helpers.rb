module Support
  module ResponseHelpers
    def response_body
      JSON.parse(response.body)
    end
  end
end
