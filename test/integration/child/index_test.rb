require 'test_helper'

class Child::IndexTest < IntegrationTest
  before do
    @user = create_login_user
    @child = create :child
  end

  stub_user_variable child_age_cutoff: 6.months.from_now

  test '#index filters' do
    visit children_path

    within('.filter_form') do
      assert_text 'First name'
      assert_text 'Last name'
      assert_text 'Birthdate'
      assert_text 'Gender'
      assert_text 'Parent pickup'
      assert_text 'Needs bed'
      assert_text 'Arrived at'
      assert_text 'Departed at'
    end
  end

  test '#index set childcare' do
    enable_javascript!
    login_user(@user)

    @child.update!(childcare_id: nil)
    @childcare = create :childcare

    visit children_path
    within("#child_#{@child.id}") do
      select_option('child[childcare_id]')
    end
    wait_for_ajax!

    refute_nil @child.reload.childcare_id
  end

  test '#index columns' do
    visit children_path

    assert_index_columns :selectable, :id, :first_name, :last_name, :family,
                         :gender, :birthdate, :age, :grade_level,
                         :parent_pickup, :needs_bed, :arrived_at, :departed_at,
                         :created_at, :updated_at, :actions
  end

  test '#index items' do
    visit children_path

    within('#index_table_children') do
      assert_selector "#child_#{@child.id}"
    end
  end

end
