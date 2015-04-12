module Notifiers
  class Base
    include ::Celluloid

    def notify(*args)
      async.perform(*args)
    end

    private
    def perform(*args)
      raise NotImplementedError
    end
  end
end