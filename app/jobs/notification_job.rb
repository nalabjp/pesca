class NotificationJob < ActiveJob::Base
  queue_as :notification

  def perform(events)
    notify_events(events)
  end

  private
  def notify_events(events)
    bullet = Notifiers.new(:pushbullet)
    events.each do |event|
      notification = Notification.new(event.title, event.description, event.event_url)
      bullet.notify(:link, notification)
      logger.info("[Notification] #{notification.title} #{notification.url}")
    end
    bullet.terminate
  end
end
