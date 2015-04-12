module Providers
  class Connpass < Base
    class << self
      def build_event(hash)
        Event.new do |e|
          e.provider    = name.demodulize.underscore
          e.event_id    = hash['event_id']
          e.title       = hash['title']
          e.description = hash['description']
          e.catch       = hash['catch']
          e.address     = hash['address']
          e.event_url   = hash['event_url']
        end
      end
    end

    private
    def endpoint
      'http://connpass.com/api/v1'
    end

    def path
      'event/'
    end

    def params
      {
        start: 1,
        count: 25,
        format: :json,
      }
    end

    def response(resp)
      resp['events']
    end
  end
end