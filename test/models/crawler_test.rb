require 'test_helper'

class ProviderMock
  include Celluloid
  def load_events; end
end

class CrawlerTest < ActiveSupport::TestCase
  test '#initialize' do
    mock = ProviderMock.new
    crawler = Crawler.new([mock])
    assert_instance_of Array, crawler.instance_variable_get(:@providers)
    assert_equal mock, crawler.instance_variable_get(:@providers).first
  end

  test '#crawl' do
    terminated = false
    proc = Proc.new { terminated = true }
    future = MiniTest::Mock.new.expect(:value, 'value')
    crawler = Crawler.new([])
    crawler.stub(:futures, [future]) do
      crawler.stub(:terminate, proc) do
        assert_equal ['value'], crawler.crawl
        assert terminated
      end
    end
  end

  test '#futures' do
    mock = ProviderMock.new
    crawler = Crawler.new([mock])
    res = crawler.send(:futures)
    assert_instance_of Array, res
    assert_instance_of Celluloid::Future, res.first
  end

  test '#values with only valid future' do
    mock = MiniTest::Mock.new.expect(:value, 'value')
    assert_equal ['value'], Crawler.new([]).send(:values, [mock])
  end

  test '#values with only invalid future' do
    mock_error = MiniTest::Mock.new.expect(:value, nil) { raise Faraday::Error.new('test') }
    assert_equal [], Crawler.new([]).send(:values, [mock_error])
  end

  test '#values with valid and invalid futures' do
    mock_error = MiniTest::Mock.new.expect(:value, nil) { raise Faraday::Error.new('test') }
    mock = MiniTest::Mock.new.expect(:value, 'value')
    assert_equal ['value'], Crawler.new([]).send(:values, [mock_error, mock])
  end

  test '#terminate' do
    mock = ProviderMock.new
    crawler = Crawler.new([mock])
    assert crawler.instance_variable_get(:@providers).first.alive?
    crawler.send(:terminate)
    refute crawler.instance_variable_get(:@providers).first.alive?
  end
end
