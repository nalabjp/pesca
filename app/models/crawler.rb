class Crawler
  def initialize(providers)
    @providers = providers
  end

  def crawl
    values(futures)
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
end
