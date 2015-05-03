require 'test_helper'

class NotifiersTest < ActiveSupport::TestCase
  test 'pushbullet' do
    assert Notifiers.new(:pushbullet).instance_of?(Notifiers::Pushbullet)
  end
end
