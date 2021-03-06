ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/rails'
require 'minitest/reporters'
require 'factory_girl'
require 'support/database_rewinder'
require 'fixtures/pesca_stub/configuration'

Minitest::Reporters.use!

class Minitest::Test
  include FactoryGirl::Syntax::Methods
end

class ActiveSupport::TestCase
  ActiveRecord::Migration.check_pending!

  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end
