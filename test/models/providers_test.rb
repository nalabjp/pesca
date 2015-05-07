require 'test_helper'

class ProvidersTest < ActiveSupport::TestCase
  test 'create instance with :atnd' do
    assert_instance_of Providers::Atnd, Providers.new(:atnd)
  end

  test 'create instance with :connpass' do
    assert_instance_of Providers::Connpass, Providers.new(:connpass)
  end

  test 'create instance with :door_keeper' do
    assert_instance_of Providers::DoorKeeper, Providers.new(:door_keeper)
  end

  test 'create instance with :zusaar' do
    assert_instance_of Providers::Zusaar, Providers.new(:zusaar)
  end

  test '.names valid values' do
    assert_empty Providers.names - %w(atnd connpass door_keeper zusaar)
  end

  test '.enabled_names with `Configuration.provider`' do
    assert_empty Providers.enabled_names - %w(connpass door_keeper zusaar)
  end

  test '.enabled_names with `.names`' do
    raise if Configuration.respond_to?(:providers?)
    Configuration.define_singleton_method :providers? do
      false
    end
    assert_empty Providers.enabled_names - %w(atnd connpass door_keeper zusaar)
    (class << Configuration; self; end).send(:remove_method, :providers?)
  end

  test '.[] with valid name' do
    assert_equal Providers::Connpass, Providers[:connpass]
    assert_equal Providers::DoorKeeper, Providers[:door_keeper]
    assert_equal Providers::Zusaar, Providers[:zusaar]
  end

  test '.[] with invalid name' do
    e1 = assert_raise NameError do
      Providers[:base]
    end
    assert_equal "Disabled provider 'base'", e1.message
    e2 = assert_raise NameError do
      Providers[:atnd]
    end
    assert_equal "Disabled provider 'atnd'", e2.message
  end

  test '.instances' do
    Providers.stub(:enabled_names, %w(connpass zusaar)) do
      assert_empty Providers.instances.map{|instance| instance.class } - [Providers::Connpass, Providers::Zusaar]
    end
  end
end
