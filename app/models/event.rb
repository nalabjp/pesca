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

class Event < ActiveRecord::Base
  validates :provider, presence: true
  validates :event_id, presence: true, uniqueness: { scope: :provider }
  validates :title, presence: true
  validates :event_url, presence: true

  class << self
    def search_by(ids:, keywords: [])
      ids = [ids.to_i] unless ids.is_a?(Array)
      keywords = [keywords.to_s] unless keywords.is_a?(Array)
      where(id: ids).ransack('title_or_description_or_catch_or_address_cont_any': keywords).result
    end
  end
end
