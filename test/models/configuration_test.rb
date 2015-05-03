require 'test_helper'

class ConfigurationTest < ActiveSupport::TestCase
  def configuration
    PescaStub::Configuration.stub_data
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