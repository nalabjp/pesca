require 'test_helper'

class Providers::ConnpassTest < ActiveSupport::TestCase
  def setup
    @connpass = Providers::Connpass.new
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
    assert_equal @connpass.instance_variable_get(:@endpoint), 'http://connpass.com/api/v1'
    assert_equal @connpass.instance_variable_get(:@path), 'event/'
    assert_equal @connpass.instance_variable_get(:@params), {start: 1, count: 25, format: :json}
  end

  test '#response' do
    params = {'events' => [{}, {}]}
    res = @connpass.send(:response, params)
    assert_instance_of Array, res
    assert_instance_of Event, res[0]
    assert_instance_of Event, res[1]
  end

  test '#build_event' do
    hash = event_hash
    event = @connpass.send(:build_event, hash)
    assert_instance_of Event, event
    attrs = event.attributes
    assert_equal attrs['provider'], 'connpass'
    assert_equal attrs['event_id'], hash['event_id']
    assert_equal attrs['title'], hash['title']
    assert_equal attrs['description'], hash['description']
    assert_equal attrs['catch'], hash['catch']
    assert_equal attrs['address'], hash['address']
    assert_equal attrs['event_url'], hash['event_url']
  end
end
