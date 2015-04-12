module Providers
  extend Initializable

  class << self
    def names
      Dir.glob(Rails.root.join('app/models', name.underscore, '**/*.rb')).map{|f| File.basename(f, '.rb')} - ['base']
    end

    def [](klass)
      class_name(klass).constantize
    end

    def instances
      arr = Configuration.providers? ? Configuration.providers : names
      arr.map{|provider| new(provider)}
    end
  end
end