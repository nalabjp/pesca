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