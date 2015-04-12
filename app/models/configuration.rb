class Configuration
  class << self
    def method_missing(name, *args)
      if config.respond_to?(name)
        config.send(name)
      else
        super
      end
    end

    private
    def config
      @config ||= Hashie::Mash.new(Rails.application.config_for(:application))
    end
  end
end