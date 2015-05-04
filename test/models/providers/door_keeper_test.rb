require 'test_helper'

class Providers::DoorKeeperTest < ActiveSupport::TestCase
  def setup
    @door_keeper = Providers::DoorKeeper.new
  end

  def event_hash
    {
      'id' => '12345678',
      'title' => 'event title',
      'description' => 'event description',
      'group' => {
        'description' => 'event catch'
      },
      'address' => 'event address',
      'public_url' => 'https://event.com/event/9876'
    }
  end

  test '#initialize' do
    assert_equal @door_keeper.instance_variable_get(:@endpoint), 'http://api.doorkeeper.jp'
    assert_equal @door_keeper.instance_variable_get(:@path), 'events'
    assert_equal @door_keeper.instance_variable_get(:@params), nil
  end

  test '#response' do
    params = [{'event' => {'group' => {}}}, {'event' => {'group' => {}}}]
    res = @door_keeper.send(:response, params)
    assert_instance_of Array, res
    assert_instance_of Event, res[0]
    assert_instance_of Event, res[1]
  end

  test '#build_event' do
    hash = event_hash
    event = @door_keeper.send(:build_event, hash)
    assert_instance_of Event, event
    attrs = event.attributes
    assert_equal attrs['provider'], 'door_keeper'
    assert_equal attrs['event_id'], hash['id']
    assert_equal attrs['title'], hash['title']
    assert_equal attrs['description'], hash['description']
    assert_equal attrs['catch'], hash['group']['description']
    assert_equal attrs['address'], hash['address']
    assert_equal attrs['event_url'], hash['public_url']
  end
end
