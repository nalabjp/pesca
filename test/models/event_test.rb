# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  provider    :string(32)       not null
#  event_id    :string(16)       not null
#  title       :string           not null
#  description :text
#  catch       :text
#  address     :string
#  event_url   :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  unique_on_provider_and_event_id  (provider,event_id) UNIQUE
#

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
    assert_equal 0, Event.search_by(ids: ids, keywords: 'provider').size
    assert_equal 2, Event.search_by(ids: ids, keywords: 'event').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'event title').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'event description').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'event catch').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'event address').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'foo').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'bar').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'baz').size
    assert_equal 1, Event.search_by(ids: ids, keywords: 'qux').size
  end
end
