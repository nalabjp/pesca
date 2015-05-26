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

FactoryGirl.define do
  factory :event_with_valid_attributes, class: Event do
    provider 'test event provider'
    event_id '123456'
    title 'test event title'
    description 'test event description'
    catch 'test event catch'
    address 'test event address'
    event_url 'http://test.event.com/event/123456'

    trait :for_search do
      provider 'for search'
      title 'event foo'
      description 'event bar'
      catch 'event baz'
      address 'event qux'
    end
  end
end
