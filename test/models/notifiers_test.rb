require 'test_helper'

class NotifiersTest < ActiveSupport::TestCase
  test 'pushbullet' do
    assert_instance_of Notifiers::Pushbullet, Notifiers.new(:pushbullet)
  end
end
