module Notifiers
  class Base
    def notify(*args)
      perform(*args)
    end

    private
    def perform(*args)
      raise NotImplementedError
    end
  end
end