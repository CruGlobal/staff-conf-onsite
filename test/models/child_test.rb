require 'test_helper'

class ChildTest < ActiveSupport::TestCase
  setup do
    create_users
    @child = create :child
  end

  test 'childcare_weeks=' do
    @child.childcare_weeks = [1, 2, 3]

    assert_equal [1, 2, 3], @child.childcare_weeks
    assert_equal '1,2,3', @child[:childcare_weeks]
  end

  test 'childcare_weeks= with empty array' do
    @child.childcare_weeks = []

    assert_equal [], @child.childcare_weeks
    assert_equal '', @child[:childcare_weeks]
  end

  test 'childcare_weeks= out of order' do
    @child.childcare_weeks = [1, 3, 2]

    assert_equal [1, 2, 3], @child.childcare_weeks
    assert_equal '1,2,3', @child[:childcare_weeks]
  end

  test 'childcare_weeks= with nil' do
    @child.childcare_weeks = nil
    assert_empty @child.childcare_weeks
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

  test '#younger?' do
    %w(age0 age1 age2 age3 age4 age5 grade1 grade2 grade3 grade4 grade5).each do |level|
      @child.grade_level = level
      assert @child.younger?
    end

    %w(grade6 grade7 grade8 grade9 grade10 grade11 grade12 grade13 postHighSchool).each do |level|
      @child.grade_level = level
      refute @child.younger?
    end
  end
end
