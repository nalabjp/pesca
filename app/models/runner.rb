class Runner
  include ::AASM

  def initialize
    @keywords = ::Configuration.filter.keywords
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
        log_info('Finish: Runner#run')
      end
    end
  end

  private
  def exec_crawl
    @crawled = Crawler.new(providers).crawl
  end

  def exec_import
    res = Event.import(@crawled)
    @inserted_ids = res[:ids]
  end

  def exec_filter
    @filtered = Event.search_by(ids: @inserted_ids, keywords: @keywords)
  end

  def exec_notify
    NotificationJob.perform_later('events', @filtered.to_a)
  end

  def providers
    Providers.instances
  end

  def new_arrival?
    @inserted_ids.present?
  end

  def find?
    @filtered.present?
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
