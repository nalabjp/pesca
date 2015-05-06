require 'test_helper'

class Providers::AtndTest < ActiveSupport::TestCase
  def setup
    @atnd = Providers::Atnd.new
  end

  def event_hash
    {
      'event_id' => '12345678',
      'title' => 'event title',
      'description' => 'event description',
      'catch' => 'event catch',
      'address' => 'event address',
      'event_url' => 'https://event.com/event/9876'
    }
  end

  test '#initialize' do
    assert_equal 'http://api.atnd.org', @atnd.instance_variable_get(:@endpoint)
    assert_equal 'events/', @atnd.instance_variable_get(:@path)
    assert_equal ({ start: 1, count: 25, format: :json }), @atnd.instance_variable_get(:@params)
  end

  test '#response' do
    params = {'events' => [{'event' => {}}, {'event' => {}}]}
    res = @atnd.send(:response, params)
    assert_instance_of Array, res
    assert_instance_of Event, res[0]
    assert_instance_of Event, res[1]
  end

  test '#build_event' do
    hash = event_hash
    event = @atnd.send(:build_event, hash)
    assert_instance_of Event, event
    attrs = event.attributes
    assert_equal 'atnd', attrs['provider']
    assert_equal hash['event_id'], attrs['event_id']
    assert_equal hash['title'], attrs['title']
    assert_equal hash['description'], attrs['description']
    assert_equal hash['catch'], attrs['catch']
    assert_equal hash['address'], attrs['address']
    assert_equal hash['event_url'], attrs['event_url']
  end
end
