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
        faraday.adapter  Faraday.default_adapter
        faraday.response :json, :content_type => /\bjson$/
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