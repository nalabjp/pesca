require 'test_helper'

class Providers::BaseTest < ActiveSupport::TestCase
  def setup
    @base = Providers::Base.new
  end

  test 'included module' do
    assert_includes @base.class.ancestors, Celluloid
  end

  test '#name' do
    assert_equal 'base', @base.name
  end

  test '#load_events' do
    @base.stub(:load, nil) do
      @base.stub(:response, 'called #response') do
        assert_equal 'called #response', @base.load_events
      end
    end
  end

  test '#connection' do
    connection = @base.send(:connection)
    handlers = connection.builder.handlers
    assert_instance_of Faraday::Connection, connection
    assert_includes handlers, Faraday::Response::Logger
    assert_includes handlers, FaradayMiddleware::ParseJson
    assert_includes handlers, Faraday::Response::RaiseError
    assert_includes handlers, Faraday::Adapter::NetHttp
    assert_equal 4, handlers.size
  end

  test '#load' do
    mock_resp = MiniTest::Mock.new.expect(:body, 'response body')
    mock_conn = MiniTest::Mock.new.expect(:get, mock_resp, [nil, nil])
    @base.instance_variable_set(:@connection, mock_conn)
    assert_equal 'response body', @base.send(:load, nil, nil)
  end

  test '#response' do
    assert_raise NotImplementedError do
      @base.send(:response, nil)
    end
  end
end
