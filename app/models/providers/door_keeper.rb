module Providers
  class DoorKeeper < Base
    class << self
      def build_event(hash)
        Event.new do |e|
          e.provider    = name.demodulize.underscore
          e.event_id    = hash['id']
          e.title       = hash['title']
          e.description = hash['description']
          e.catch       = hash['group']['description']
          e.address     = hash['address']
          e.event_url   = hash['public_url']
        end
      end
    end

    private
    def endpoint
      'http://api.doorkeeper.jp'
    end

    def path
      'events'
    end

    def response(resp)
      resp.inject([]) do |arr, hash|
        arr.push(hash['event'])
        arr
      end
    end
  end
end