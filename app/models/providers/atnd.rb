module Providers
  class Atnd < Base
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
      'http://api.atnd.org'
    end

    def path
      'events/'
    end

    def params
      {
        start: 1,
        count: 25,
        format: :json,
      }
    end

    def response(resp)
      resp['events'].inject([]) do |arr, hash|
        arr.push(hash['event'])
        arr
      end
    end
  end
end