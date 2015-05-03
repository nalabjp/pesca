require 'test_helper'

class Pesca::Stub
  def self.configuration
    {
      'providers' => %w(zusaar connpass door_keeper),
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
end

class ConfigurationTest < ActiveSupport::TestCase

  test '.config' do
    Rails.application.stub(:config_for, Pesca::Stub.configuration) do
      assert Configuration.send(:config).instance_of?(Hashie::Mash)
    end
  end

  test '.method_missing exist key' do
    Rails.application.stub(:config_for, Pesca::Stub.configuration) do
      assert_equal Configuration.providers, Pesca::Stub.configuration['providers']
      assert_equal Configuration.notifiers, Pesca::Stub.configuration['notifiers']
      assert_equal Configuration.filter, Pesca::Stub.configuration['filter']
    end
  end

  test '.method_missing not found key' do
    Rails.application.stub(:config_for, Pesca::Stub.configuration) do
      assert_raise NoMethodError do
        Configuration.not_found_key
      end
    end
  end
end