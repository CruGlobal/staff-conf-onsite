require 'test_helper'

class Attendee::FormTest < IntegrationTest
  before do
    @user = create_login_user
    @attendee = create :attendee
  end

  test '#edit fields' do
    visit edit_attendee_path(@attendee)

    assert_edit_fields :student_number, :first_name, :last_name, :gender,
                       :birthdate, :arrived_at, :departed_at, :email, :phone,
                       :emergency_contact, :ministry_id, :department,
                       record: @attendee

    assert_active_admin_comments
  end

  test '#new record creation' do
    @family = create :family
    attr = attributes_for :attendee

    visit edit_family_path(@family)
    click_link 'New Attendee'

    assert_difference 'Attendee.count' do
      within('form#new_attendee') do
        fill_in 'Student number',            with: attr[:student_number]
        fill_in 'First name',            with: attr[:first_name]
        fill_in 'Last name',            with: attr[:last_name]
        select 'Male', from: 'Gender'
      end

      click_button 'Create Attendee'
    end
  end
end
