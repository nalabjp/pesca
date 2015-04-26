require 'test_helper'
class EventTest < ActiveSupport::TestCase
  def event(*args)
    options = args.extract_options!
    build(:event_with_valid_attributes, *args, options)
  end

  def test_valid
    assert event.valid?
  end

  def test_empty_provider
    refute event(provider: nil).valid?
  end

  def test_empty_event_id
    refute event(event_id: nil).valid?
  end

  def test_empty_title
    refute event(title: nil).valid?
  end

  def test_empty_event_url
    refute event(event_url: nil).valid?
  end

  def test_provider_and_event_id_unique
    event.save!
    refute event.valid?
  end

  def test_next_auto_increment_id
    prev_next_id = Event.next_auto_increment_id
    current_next_id = Event.next_auto_increment_id
    assert current_next_id >= (prev_next_id + 1)
  end

  def test_search_by
    e1 = event
    e1.save!
    e2 = event(:for_search)
    e2.save!
    ids = [e1.id, e2.id]
    assert_equal Event.search_by(ids: Event.next_auto_increment_id).size, 0
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
