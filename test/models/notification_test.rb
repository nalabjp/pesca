require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test 'Notification.new' do
    notification = Notification.new('title1', '<h1>body1</h1>', 'http://event.com/evnet/1234')
    assert_equal 'title1', notification.title
    assert_equal 'body1', notification.body
    assert_equal 'http://event.com/evnet/1234', notification.url
  end
end

class Notification::ErrorTest < ActiveSupport::TestCase
  test 'Notification::Error.new' do
    error = Notification::Error.new('title2', %w(body1 body2))
    assert_equal 'title2', error.title
    assert_equal "title2\n\n  body1\n  body2\n", error.body
  end
end
