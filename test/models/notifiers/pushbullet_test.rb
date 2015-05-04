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

    assert_equal @bullet.send(:perform, :link, 'msg of link'), 'msg of link'
    assert_equal @bullet.send(:perform, :note, 'msg of note'), 'msg of note'
  end

  test '#client' do
    assert_instance_of Washbullet::Client, @bullet.send(:client)
  end

  test '#devices' do
    devices = [Object.new]
    mock = MiniTest::Mock.new.expect(:devices, devices)
    @bullet.stub(:client, mock) do
      assert_equal @bullet.send(:devices), devices
    end
  end

  test '#push_link' do
    device = MiniTest::Mock.new
    device.expect(:nickname, 'iPhone6')
    @bullet.stub(:devices, [device]) do
      @bullet.stub(:push_link, 'push_link called') do
        assert_equal @bullet.send(:push_link, nil), 'push_link called'
      end
    end
  end

  test '#push_note' do
    device = MiniTest::Mock.new
    device.expect(:nickname, 'iPhone6')
    @bullet.stub(:devices, [device]) do
      @bullet.stub(:push_note, 'push_note called') do
        assert_equal @bullet.send(:push_note, nil), 'push_note called'
      end
    end
  end
end
