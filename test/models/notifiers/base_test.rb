require 'test_helper'

class Notifiers::BaseTest < ActiveSupport::TestCase
  test '#notify' do
    base = Notifiers::Base.new
    base.define_singleton_method(:perform) do |arg|
      arg
    end

    assert_equal 'called #notify', base.notify('called #notify')
  end

  test '#perform' do
    assert_raise NotImplementedError do
      Notifiers::Base.new.send(:perform)
    end
  end
end
