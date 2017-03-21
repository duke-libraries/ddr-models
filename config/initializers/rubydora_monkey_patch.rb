module Rubydora
  class Datastream
    def entity_size(response)
      if content_length = response["content-length"]
        content_length.to_i
      else
        response.body.length
      end
    end
  end
end
