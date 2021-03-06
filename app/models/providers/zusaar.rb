module Providers
  class Zusaar < Base
    def initialize
      super
      @endpoint = 'http://www.zusaar.com/api'
      @path = 'event/'
      @params = {
        start: 1,
        count: 25,
        format: :json,
      }
    end

    private
    def response(resp)
      resp['event'].map do |event|
        build_event(event)
      end
    end

    def build_event(hash)
      Event.new do |e|
        e.provider    = name
        e.event_id    = hash['event_id']
        e.title       = hash['title']
        e.description = hash['description']
        e.catch       = hash['catch']
        e.address     = hash['address']
        e.event_url   = hash['event_url']
      end
    end
  end
end