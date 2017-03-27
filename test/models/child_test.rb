require 'test_helper'

class ChildTest < ModelTestCase
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

  %w(age0 age1 age2 age3 age4 age5 grade1 grade2 grade3 grade4 grade5).each do |level|
    test "#age_group is :childcare when grade level is #{level}" do
      @child.grade_level = level
      assert_equal :childcare, @child.age_group
    end
  end

  %w(grade6 grade7 grade8 grade9 grade10 grade11 grade12 grade13).each do |level|
    test "#age_group is :junior_senior when grade level is #{level}" do
      @child.grade_level = level
      assert_equal :junior_senior, @child.age_group
    end
  end

  [nil, 'postHighSchool'].each do |level|
    test "#age_group is :post_high_school when grade level is #{level}" do
      @child.grade_level = level
      assert_equal :post_high_school, @child.age_group
    end
  end

  test 'hot_lunch_weeks=' do
    @child.hot_lunch_weeks = [1, 2, 3]

    assert_equal [1, 2, 3], @child.hot_lunch_weeks
    assert_equal '1,2,3', @child[:hot_lunch_weeks]
  end

  test 'hot_lunch_weeks= with empty array' do
    @child.hot_lunch_weeks = []

    assert_equal [], @child.hot_lunch_weeks
    assert_equal '', @child[:hot_lunch_weeks]
  end

  test 'hot_lunch_weeks= out of order' do
    @child.hot_lunch_weeks = [1, 3, 2]

    assert_equal [1, 2, 3], @child.hot_lunch_weeks
    assert_equal '1,2,3', @child[:hot_lunch_weeks]
  end

  test 'hot_lunch_weeks= with nil' do
    @child.hot_lunch_weeks = nil
    assert_empty @child.hot_lunch_weeks
  end
end
