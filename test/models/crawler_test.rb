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
    assert_equal crawler.instance_variable_get(:@providers).first, mock
  end

  test '#crawl' do
    terminated = false
    proc = Proc.new { terminated = true }
    future = MiniTest::Mock.new.expect(:value, 'value')
    crawler = Crawler.new([])
    crawler.stub(:futures, [future]) do
      crawler.stub(:terminate, proc) do
        assert_equal crawler.crawl, ['value']
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

  test '#values' do
    mock = MiniTest::Mock.new.expect(:value, 'value')
    assert_equal Crawler.new([]).send(:values, [mock]), ['value']
  end

  test '#terminate' do
    mock = ProviderMock.new
    crawler = Crawler.new([mock])
    assert crawler.instance_variable_get(:@providers).first.alive?
    crawler.send(:terminate)
    refute crawler.instance_variable_get(:@providers).first.alive?
  end
end
