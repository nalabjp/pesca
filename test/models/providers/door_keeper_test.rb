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
    assert_equal 'http://api.doorkeeper.jp', @door_keeper.instance_variable_get(:@endpoint)
    assert_equal 'events', @door_keeper.instance_variable_get(:@path)
    assert_equal ({locale: 'ja'}), @door_keeper.instance_variable_get(:@params)
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
    assert_equal 'door_keeper', attrs['provider']
    assert_equal hash['id'], attrs['event_id']
    assert_equal hash['title'], attrs['title']
    assert_equal hash['description'], attrs['description']
    assert_equal hash['group']['description'], attrs['catch']
    assert_equal hash['address'], attrs['address']
    assert_equal hash['public_url'], attrs['event_url']
  end
end
