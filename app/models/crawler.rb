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
    futures.map(&:value).flatten
  end

  def terminate
    @providers.each{|p| p.terminate}
  end
end
