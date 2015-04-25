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
    assert event(provider: nil).invalid?
  end

  def test_empty_event_id
    assert event(event_id: nil).invalid?
  end

  def test_empty_title
    assert event(title: nil).invalid?
  end

  def test_empty_event_url
    assert event(event_url: nil).invalid?
  end

  def test_provider_and_event_id_unique
    event.save!
    assert event.invalid?
  end

  def test_next_auto_increment_id
    prev_next_id = Event.next_auto_increment_id
    current_next_id = Event.next_auto_increment_id
    assert_equal current_next_id, (prev_next_id + 1)
  end

  def test_search_by
    event.save!
    id1 = Event.last.id
    event(:for_search).save!
    id2 = Event.last.id
    ids = [id1, id2]
    assert_equal Event.search_by(ids: id2+1).size, 0
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
