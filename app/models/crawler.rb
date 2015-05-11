class Crawler
  def initialize(providers)
    @providers = providers
  end

  def crawl
    begin
      values(futures)
    ensure
      terminate
    end
  end

  private
  def futures
    @providers.map do |provider|
      provider.future.load_events
    end
  end

  def values(futures)
    futures.map do |future|
      begin
        future.value
      rescue => e
        Rails.logger.error(e.message)
        []
      end
    end.flatten
  end

  def terminate
    @providers.each{|p| p.terminate if p.alive? }
  end
end
