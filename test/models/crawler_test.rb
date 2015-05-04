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
    mock = ProviderMock.new
    crawler = Crawler.new([mock])
    res = crawler.crawl
    assert_instance_of Array, res
    assert_instance_of Celluloid::Future, res.first
  end
end
