require 'test_helper'

class Notifiers::BaseTest < ActiveSupport::TestCase
  test '#notify' do
    base = Notifiers::Base.new
    base.define_singleton_method(:perform) do
      true
    end

    assert base.notify
  end

  test '#perform' do
    assert_raise NotImplementedError do
      Notifiers::Base.new.send(:perform)
    end
  end
end