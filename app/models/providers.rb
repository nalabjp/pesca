module Providers
  extend Initializable

  class << self
    def names
      Dir.glob(Rails.root.join('app/models', name.underscore, '**/*.rb')).map{|f| File.basename(f, '.rb')} - ['base']
    end

    def enabled_names
      @enabled_names ||= Configuration.providers? ? (Configuration.providers & names) : names
    end

    def [](klass)
      if klass.to_s.in?(enabled_names)
        class_name(klass).constantize
      else
        raise NameError.new("Disabled provider '#{klass}'")
      end
    end

    def instances
      enabled_names.map{|provider| new(provider)}
    end
  end
end