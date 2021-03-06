module ITunes
  module Request

    # @private
    private

    # Perform an HTTP GET request
    def request(request_type, params)
      # url = '/WebObjects/MZStoreServices.woa/wa/ws' + request_type
      url = '/' + request_type.downcase

      response = connection.get do |req|
        req.url url, params
        req.options.timeout = request_options[:timeout] if request_options[:timeout].present?
        req.options.open_timeout = request_options[:open_timeout] if request_options[:open_timeout].present?
      end
      response.body
    end

    def connection
      options = {
        :headers => {'Accept' => 'application/json', 'User-Agent' => user_agent},
        :url => api_endpoint,
      }

      Faraday.new(options) do |builder|
        builder.use Faraday::Response::Rashify
        builder.use Faraday::Response::ParseJson
        builder.adapter(adapter)
      end
    end
  end
end
