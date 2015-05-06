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
    assert_equal configuration['providers'], Configuration.providers
    assert_equal configuration['notifiers'], Configuration.notifiers
    assert_equal configuration['filter'], Configuration.filter
  end

  test '.method_missing not found key' do
    assert_raise NoMethodError do
      Configuration.not_found_key
    end
  end
end
