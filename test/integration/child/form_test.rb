require 'test_helper'

class Child::FormTest < IntegrationTest
  before do
    @user = create_login_user
    @child = create :child, :childcare
    @childcare = create :childcare
  end

  stub_user_variable child_age_cutoff: 6.months.from_now,
                     rec_center_daily: Money.new(1_00)

  test '#edit fields' do
    visit edit_child_path(@child)

    assert_edit_fields :first_name, :last_name, :gender, :birthdate,
                       :grade_level, :parent_pickup, :needs_bed, :arrived_at,
                       :departed_at, :childcare_weeks, :childcare_id,
                       :rec_center_pass_started_at, :rec_center_pass_expired_at, 
                       record: @child

    assert_active_admin_comments
  end

  test 'general users cannot change #childcare_deposit' do
    @user = create_login_user :general
    visit edit_child_path(@child)

    assert_selector '#child_childcare_deposit[disabled]'
  end

  test '#edit add cost_adjustment' do
    enable_javascript!
    login_user(@user)

    attrs = attributes_for :cost_adjustment

    visit edit_child_path(@child)

    assert_difference "CostAdjustment.where(person_id: #{@child.id}).count" do
      within('.cost_adjustments.panel') do
        click_link 'Add New Cost adjustment'

        select_option('Cost type')
        fill_in 'Price', with: attrs[:price_cents]
        fill_in 'Percent', with: attrs[:percent]
        fill_in 'Description', with: attrs[:description]
      end

      click_button 'Update Child'
      assert_current_path child_path(@child)
    end
  end

  test '#new record creation' do
    enable_javascript!
    login_user(@user)

    @family = create :family
    attrs = attributes_for :child

    visit edit_family_path(@family)
    click_link 'New Child'

    assert_difference ['Child.count'] do
      within('form#new_child') do
        # basic details
        fill_in 'First name', with: attrs[:first_name]
        fill_in 'Last name',  with: attrs[:last_name]
        fill_in 'Birthdate',  with: attrs[:birthdate]

        select_option('Gender')
        select_option('Age Group or Grade Level', value: "Grade 5")

        check 'Parent pickup'
        check 'Needs bed'

        fill_in 'Rec Center Pass Start Date', with: attrs[:rec_center_pass_started_at]
        fill_in 'Rec Center Pass End Date',   with: attrs[:rec_center_pass_expired_at]

        # duration
        fill_in 'Requested Arrival date',  with: attrs[:arrived_at]
        fill_in 'Requested Departure date', with: attrs[:departed_at]

        # childcare
        select_option('Weeks of ChildCare')
        select_option('Weeks of ChildCare')
        select_option('Childcare Spaces', include_blank: true)
      end

      click_button 'Create Child'
      assert_selector('body.show.children')
    end
  end

end
