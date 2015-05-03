require 'test_helper'

module ExampleModule
  extend Initializable
end
class ExampleModule::Example1; end
class ExampleModule::Example2; end

class InitializableTest < ActiveSupport::TestCase
  test 'added class method' do
    assert ExampleModule.respond_to?(:new)
    assert ExampleModule.respond_to?(:class_name)
  end

  test '.class_name' do
    assert_equal ExampleModule.class_name(:example1), 'ExampleModule::Example1'
    assert_equal ExampleModule.class_name(:example2), 'ExampleModule::Example2'
  end

  test '.new' do
    assert ExampleModule.new(:example1).instance_of?(ExampleModule::Example1)
    assert ExampleModule.new(:example2).instance_of?(ExampleModule::Example2)
  end
end
