class Runner
  include ::AASM

  def initialize
    @keywords = ::Configuration.filter.keywords
    @providers = nil
    @crawled = nil
    @inserted_id_range = nil
    @filtered = nil
    @notifications = nil
    @mutex = Mutex.new
  end

  aasm whiny_transitions: false do
    state :prepare, initial: true
    state :crawling
    state :importing
    state :filtering
    state :notifying

    event :crawl do
      transitions from: :prepare, to: :crawling do
        after do
          log_info('Finish event: :crawl')
        end
      end
    end

    event :import do
      transitions from: :crawling, to: :importing do
        after do
          log_info('Finish event: :import')
        end
      end
    end

    event :filter do
      transitions from: :importing, to: :filtering, guard: :new_arrival? do
        after do
          log_info('Finish event: :filter')
        end
      end
    end

    event :notify do
      transitions from: :filtering, to: :notifying, guard: :find? do
        after do
          log_info('Finish event: :notify')
        end
      end
    end
  end

  def run
    @mutex.synchronize do
      raise AlreadyRunOnceError unless may_crawl?

      begin
        log_info('Start: Runner#run')
        crawl { exec_crawl }
        import { exec_import }
        return unless filter { exec_filter }
        notify { exec_notify }
      rescue => e
        notify_exception(e)
        raise e
      ensure
        providers.each{|p| p.terminate}
        log_info('Finish: Runner#run')
      end
    end
  end

  private
  def providers
    @providers ||= Providers.instances
  end

  def exec_crawl
    @crawled = Crawler.new(providers).crawl
  end

  def new_arrival?
    @inserted_id_range.present?
  end

  def build_events
    @crawled.map do |provider, futures|
      futures.value.map do |event|
        Providers[provider].build_event(event)
      end
    end.flatten!
  end

  def exec_import
    before_last_id = Event.next_auto_increment_id
    Event.import(build_events)
    after_last_id = Event.maximum(:id) || 0
    @inserted_id_range = after_last_id >= before_last_id ? before_last_id..after_last_id : nil
  end

  def exec_filter
    @filtered = Event.search_by(ids: @inserted_id_range.to_a, keywords: @keywords)
  end

  def find?
    @filtered.present?
  end

  def build_notifications
    @notifications = @filtered.map do |event|
      Notification.new(event.title, event.description, event.event_url)
    end
  end

  def exec_notify
    bullet = Notifiers.new(:pushbullet)
    build_notifications.each do |notification|
      bullet.notify(:link, notification)
      log_info("[Notification] #{notification.title} #{notification.url}")
    end
    bullet.terminate
  end

  def notify_exception(ex)
    bullet = Notifiers.new(:pushbullet)
    bullet.notify(:note, Notification::Error.new(ex.message, ex.backtrace))
    bullet.terminate
  end

  def log_info(message = nil)
    Rails.logger.info(message) if message
  end

  class AlreadyRunOnceError < StandardError
    def message
      'I already run once . More than two times can not be executed.'
    end
  end
end
