require 'test_helper'

class EventTest < ActiveSupport::TestCase
  def event(*args)
    options = args.extract_options!
    build(:event_with_valid_attributes, *args, options)
  end

  test 'valid' do
    assert event.valid?
  end

  test 'empty_provider' do
    refute event(provider: nil).valid?
  end

  test 'empty_event_id' do
    refute event(event_id: nil).valid?
  end

  test 'empty_title' do
    refute event(title: nil).valid?
  end

  test 'empty_event_url' do
    refute event(event_url: nil).valid?
  end

  test 'provider_and_event_id_unique' do
    event.save!
    refute event.valid?
  end

  test 'search_by' do
    res = Event.import([event, event(:for_search)])
    ids = res[:ids]
    assert_equal Event.search_by(ids: ids, keywords: 'provider').size, 0
    assert_equal Event.search_by(ids: ids, keywords: 'event').size, 2
    assert_equal Event.search_by(ids: ids, keywords: 'event title').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'event description').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'event catch').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'event address').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'foo').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'bar').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'baz').size, 1
    assert_equal Event.search_by(ids: ids, keywords: 'qux').size, 1
  end
end
