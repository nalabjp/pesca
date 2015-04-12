class Crawler
  def initialize(providers)
    @providers = providers
  end

  def crawl
    @providers.inject({}) do |hash, provider|
      hash[provider.name.to_sym] = provider.future.load_events
      hash
    end
  end
end
