module Providers
  class DoorKeeper < Base
    def initialize
      super
      @endpoint = 'http://api.doorkeeper.jp'
      @path = 'events'
    end

    private
    def response(resp)
      resp.map do |hash|
        build_event(hash['event'])
      end
    end

    def build_event(hash)
      Event.new do |e|
        e.provider    = name
        e.event_id    = hash['id']
        e.title       = hash['title']
        e.description = hash['description']
        e.catch       = hash['group']['description']
        e.address     = hash['address']
        e.event_url   = hash['public_url']
      end
    end
  end
end