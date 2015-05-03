class Runner
  include ::AASM

  def initialize
    @keywords = ::Configuration.filter.keywords
    @providers = nil
    @crawled = nil
    @inserted_ids = nil
    @filtered = nil
    @mutex = Mutex.new
  end

  aasm do
    state :prepare, initial: true
    state :crawled
    state :imported
    state :filtered
    state :notified

    event :crawl do
      transitions from: :prepare, to: :crawled do
        after do
          exec_crawl
          log_info('Finish event: :crawl')
        end
      end
    end

    event :import do
      transitions from: :crawled, to: :imported do
        after do
          exec_import
          log_info('Finish event: :import')
        end
      end
    end

    event :filter do
      transitions from: :imported, to: :filtered, guard: :new_arrival? do
        after do
          exec_filter
          log_info('Finish event: :filter')
        end
      end
    end

    event :notify do
      transitions from: :filtered, to: :notified, guard: :find? do
        after do
          exec_notify
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
        crawl
        import
        filter
        notify
      rescue AASM::InvalidTransition => e
        log_info(e.message)
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
    @inserted_ids.present?
  end

  def build_events
    @crawled.map do |provider, futures|
      futures.value.map do |event|
        Providers[provider].build_event(event)
      end
    end.flatten!
  end

  def exec_import
    res = Event.import(build_events)
    @inserted_ids = res[:ids]
  end

  def exec_filter
    @filtered = Event.search_by(ids: @inserted_ids, keywords: @keywords)
  end

  def find?
    @filtered.present?
  end

  def exec_notify
    NotificationJob.perform_later('events', @filtered.to_a)
  end

  def notify_exception(ex)
    NotificationJob.perform_later('exception', ex.message, ex.backtrace)
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
