module Notifiers
  class Pushbullet < Base
    delegate :access_token, :targets, to: :@config

    def initialize
      @config = Configuration.notifiers.pushbullet
    end

    private
    def perform(method, notification)
      send("push_#{method}", notification)
    end

    def push_link(notification)
      devices.each do |device|
        if device.nickname.in?(targets)
          client.push_link(
            receiver:   :device,
            identifier: device.identifier,
            params: {
              title: notification.title,
              url:   notification.url,
              body:  notification.body
            }
          )
        end
      end
    end

    def push_note(notification)
      devices.each do |device|
        if device.nickname.in?(targets)
          client.push_note(
            receiver:   :device,
            identifier: device.identifier,
            params: {
              title: notification.title,
              body:  notification.body
            }
          )
        end
      end
    end

    def client
      @client ||= ::Washbullet::Client.new(access_token)
    end

    def devices
      @devices ||= client.devices
    end
  end
end