class Crawler
  def initialize(providers)
    @providers = providers
  end

  def crawl
    @providers.map do |provider|
      provider.future.load_events
    end
  end
end
