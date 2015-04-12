module Providers
  class Base
    include ::Celluloid

    def name
      self.class.name.demodulize.underscore
    end

    def load_events
      response(load(path, params))
    end

    private
    def connection
      @connection ||= Faraday.new(endpoint) do |faraday|
        faraday.response :logger
        faraday.adapter  Faraday.default_adapter
        faraday.response :json, :content_type => /\bjson$/
      end
    end

    def endpoint
      raise NotImplementedError.new('Require implementation in subclass')
    end

    def path
      raise NotImplementedError.new('Require implementation in subclass')
    end

    def params
      {}
    end

    def load(path, params)
      connection.get(path, params).body
    end

    def response(resp)
      raise NotImplementedError.new('Require implementation in subclass')
    end
  end
end