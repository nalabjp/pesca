require 'test_helper'

module ExampleModule
  extend Initializable
end
class ExampleModule::Example1; end
class ExampleModule::Example2; end

class InitializableTest < ActiveSupport::TestCase
  test 'added class method' do
    assert_respond_to ExampleModule, :new
    assert_respond_to ExampleModule, :class_name
  end

  test '.class_name' do
    assert_equal 'ExampleModule::Example1', ExampleModule.class_name(:example1)
    assert_equal 'ExampleModule::Example2', ExampleModule.class_name(:example2)
  end

  test '.new' do
    assert_instance_of ExampleModule::Example1, ExampleModule.new(:example1)
    assert_instance_of ExampleModule::Example2, ExampleModule.new(:example2)
  end
end
