require 'test_helper'

class Notifiers::PushBulletTest < ActiveSupport::TestCase
  def setup
    @bullet = Notifiers::Pushbullet.new
  end

  test '#initialize' do
    refute_nil @bullet.instance_variable_get(:@config)
  end

  test 'delegate' do
    assert_respond_to @bullet, :access_token
    assert_respond_to @bullet, :targets
  end

  test '#perform' do
    @bullet.define_singleton_method(:push_link) do |notification|
      notification
    end
    @bullet.define_singleton_method(:push_note) do |notification|
      notification
    end

    assert_equal 'msg of link', @bullet.send(:perform, :link, 'msg of link')
    assert_equal 'msg of note', @bullet.send(:perform, :note, 'msg of note')
  end

  test '#client' do
    assert_instance_of Washbullet::Client, @bullet.send(:client)
  end

  test '#devices' do
    devices = [Object.new]
    mock = MiniTest::Mock.new.expect(:devices, devices)
    @bullet.stub(:client, mock) do
      assert_equal devices, @bullet.send(:devices)
    end
  end

  test '#push_link' do
    device = MiniTest::Mock.new
    device.expect(:nickname, 'iPhone6')
    device.expect(:identifier, 'aabbcc112233')
    res = {}
    client = MiniTest::Mock.new
    client.expect(:push_link, nil) do |arg|
      res[:receiver] = arg[:receiver]
      res[:identifier] = arg[:identifier]
      res[:params] = arg[:params]
    end
    notification = OpenStruct.new({
                                    title: 'title!!',
                                    url: 'http://test_url.com',
                                    body: 'body!!'
                                  })
    @bullet.stub(:devices, [device]) do
      @bullet.stub(:client, client) do
        @bullet.send(
          :push_link,
          notification
        )
        assert_equal :device, res[:receiver]
        assert_equal 'aabbcc112233', res[:identifier]
        assert_equal 'title!!', res[:params][:title]
        assert_equal 'http://test_url.com', res[:params][:url]
        assert_equal 'body!!', res[:params][:body]
      end
    end
  end

  test '#push_note' do
    device = MiniTest::Mock.new
    device.expect(:nickname, 'iPhone6')
    device.expect(:identifier, 'aabbcc112233')
    res = {}
    client = MiniTest::Mock.new
    client.expect(:push_note, nil) do |arg|
      res[:receiver] = arg[:receiver]
      res[:identifier] = arg[:identifier]
      res[:params] = arg[:params]
    end
    notification = OpenStruct.new({
                                    title: 'title!!',
                                    body: 'body!!'
                                  })
    @bullet.stub(:devices, [device]) do
      @bullet.stub(:client, client) do
        @bullet.send(
          :push_note,
          notification
        )
        assert_equal :device, res[:receiver]
        assert_equal 'aabbcc112233', res[:identifier]
        assert_equal 'title!!', res[:params][:title]
        assert_equal 'body!!', res[:params][:body]
      end
    end
  end
end
