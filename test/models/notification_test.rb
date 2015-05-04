require 'test_helper'

class NotificationTest < ActiveSupport::TestCase
  test 'Notification.new' do
    notification = Notification.new('title1', '<h1>body1</h1>', 'http://event.com/evnet/1234')
    assert_equal notification.title, 'title1'
    assert_equal notification.body, 'body1'
    assert_equal notification.url, 'http://event.com/evnet/1234'
  end
end

class Notification::ErrorTest < ActiveSupport::TestCase
  test 'Notification::Error.new' do
    error = Notification::Error.new('title2', %w(body1 body2))
    assert_equal error.title, 'title2'
    assert_equal error.body, "title2\n\n  body1\n  body2\n"
  end
end