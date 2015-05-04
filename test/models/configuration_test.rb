require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  def configuration
    {
      'providers'=> %w(zusaar connpass door_keeper),
      'notifiers' => {
        'pushbullet' => {
          'access_token' => 'pushbullet_access_token',
          'targets' => ['iPhone6']
        }
      },
      'filter' => {
        'keywords' => []
      }
    }
  end

  test '.config' do
    assert_instance_of Hashie::Mash, Configuration.send(:config)
  end

  test '.method_missing exist key' do
    assert_equal Configuration.providers, configuration['providers']
    assert_equal Configuration.notifiers, configuration['notifiers']
    assert_equal Configuration.filter, configuration['filter']
  end

  test '.method_missing not found key' do
    assert_raise NoMethodError do
      Configuration.not_found_key
    end
  end
end