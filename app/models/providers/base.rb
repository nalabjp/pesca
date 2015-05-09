module Providers
  class Base
    include ::Celluloid

    def initialize
      @endpoint = nil
      @path = nil
      @params = nil
    end

    def name
      self.class.name.demodulize.underscore
    end

    def load_events
      response(load(@path, @params))
    end

    private
    def connection
      @connection ||= Faraday.new(@endpoint) do |faraday|
        faraday.response :logger
        faraday.response :json, :content_type => /\bjson$/
        faraday.response :raise_error
        faraday.adapter  Faraday.default_adapter
      end
    end

    def load(path, params)
      connection.get(path, params).body
    end

    def response(resp)
      raise NotImplementedError.new('Require implementation in subclass')
    end
  end
end