# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  nickname   :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def user(*args)
    options = args.extract_options!
    build(:user_with_valid_attributes, *args, options)
  end

  test 'valid' do
    assert user.valid?
  end

  test 'empty nickname' do
    refute user(nickname: nil).valid?
  end
end
