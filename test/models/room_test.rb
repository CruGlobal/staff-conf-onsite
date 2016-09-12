require 'test_helper'

class RoomTest < ActiveSupport::TestCase
  setup do
    create_users
    @room = create :room
  end

  test 'permit create' do
    assert_permit @general_user, @room, :create
    assert_permit @finance_user, @room, :create
    assert_permit @admin_user, @room, :create
  end

  test 'permit read' do
    assert_permit @general_user, @room, :show
    assert_permit @finance_user, @room, :show
    assert_permit @admin_user, @room, :show
  end

  test 'permit update' do
    assert_permit @general_user, @room, :update
    assert_permit @finance_user, @room, :update
    assert_permit @admin_user, @room, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @room, :destroy
    assert_permit @finance_user, @room, :destroy
    assert_permit @admin_user, @room, :destroy
  end
end
