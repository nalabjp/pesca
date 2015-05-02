class NotificationJob < ActiveJob::Base
  queue_as :notification

  def perform(*args)
    kind = args.shift
    send("notify_#{kind}", *args)
  end

  private
  def notify_events(events)
    bullet = Notifiers.new(:pushbullet)
    events.each do |event|
      notification = Notification.new(event.title, event.description, event.event_url)
      bullet.notify(:link, notification)
      logger.info("Send notification: #{notification.title} #{notification.url}")
    end
  end

  def notify_exception(message, backtrace)
    Notifiers.new(:pushbullet).notify(:note, Notification::Error.new(message, backtrace))
  end
end
