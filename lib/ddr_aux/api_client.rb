module DdrAux
  class ApiClient

    class << self
      attr_accessor :url

      delegate :license, :licenses, to: :new
    end

    self.url = ENV["DDR_AUX_API_URL"] || "http://localhost:3030/api"

    def license(code)
      get_response "/licenses/#{URI.escape(code)}"
    end

    def licenses
      get_response "/licenses"
    end

    private

    def get_response(path)
      uri = URI(self.class.url + path)
      use_ssl = (uri.scheme == "https")
      res = Net::HTTP.start(uri.host, uri.port, use_ssl: use_ssl) do |request|
        request.get(uri.path, {"Accept"=>"application/json"})
      end
      res.value # raises exception if not 2XX response code
      JSON.parse(res.body)
    end

    def connection(*args)
      Net::HTTP.new(*args)
    end

  end
end
