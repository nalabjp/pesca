# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ActiveRecord::Base
  validates :nickname, presence: true
end
