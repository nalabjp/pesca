require 'test_helper'

class Providers::BaseTest < ActiveSupport::TestCase
  def setup
    @base = Providers::Base.new
  end

  test 'included module' do
    assert_includes @base.class.ancestors, Celluloid
  end

  test '#name' do
    assert_equal @base.name, 'base'
  end

  test '#load_events' do
    @base.stub(:load, nil) do
      @base.stub(:response, 'called #response') do
        assert_equal @base.load_events, 'called #response'
      end
    end
  end

  test '#connection' do
    assert_instance_of Faraday::Connection, @base.send(:connection)
  end

  test '#load' do
    mock_resp = MiniTest::Mock.new.expect(:body, 'response body')
    mock_conn = MiniTest::Mock.new.expect(:get, mock_resp, [nil, nil])
    @base.instance_variable_set(:@connection, mock_conn)
    assert_equal @base.send(:load, nil, nil), 'response body'
  end

  test '#response' do
    assert_raise NotImplementedError do
      @base.send(:response, nil)
    end
  end
end
