# == Schema Information
#
# Table name: events
#
#  id          :integer          not null, primary key
#  provider    :string(32)       not null
#  event_id    :string(16)       not null
#  title       :string(255)      not null
#  description :text(16777215)
#  catch       :text(16777215)
#  address     :string(255)
#  event_url   :string(255)      not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
# Indexes
#
#  unique_on_provider_and_event_id  (provider,event_id) UNIQUE
#

FactoryGirl.define do
  factory :event do
    provider "MyString"
event_id "MyString"
  end

end
