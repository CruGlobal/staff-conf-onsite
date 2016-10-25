require 'test_helper'

class ChildTest < ActiveSupport::TestCase
  setup do
    create_users
    @child = create :child
  end

  test 'permit create' do
    assert_permit @general_user, @child, :create
    assert_permit @finance_user, @child, :create
    assert_permit @admin_user, @child, :create
  end

  test 'permit read' do
    assert_permit @general_user, @child, :show
    assert_permit @finance_user, @child, :show
    assert_permit @admin_user, @child, :show
  end

  test 'permit update' do
    assert_permit @general_user, @child, :update
    assert_permit @finance_user, @child, :update
    assert_permit @admin_user, @child, :update
  end

  test 'permit destroy' do
    assert_permit @general_user, @child, :destroy
    assert_permit @finance_user, @child, :destroy
    assert_permit @admin_user, @child, :destroy
  end

  test 'must have family' do
    @child = build :child, family_id: nil
    refute @child.valid?, 'child should be invalid with nil family_id'
  end

  test 'last_name should default to family name' do
    @family = create :family, last_name: 'FooBar'
    @child = create :child, family_id: @family.id, last_name: nil

    assert_equal 'FooBar', @child.last_name
  end

  test 'family name should not override explicit last_name' do
    @family = create :family, last_name: 'FooBar'
    @child = create :child, family_id: @family.id, last_name: 'OtherName'

    assert_equal 'OtherName', @child.last_name
  end
end
