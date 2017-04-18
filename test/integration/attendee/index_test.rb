require 'test_helper'

class Attendee::IndexTest < IntegrationTest
  before do
    @user = create_login_user
    @attendee = create :attendee
  end

  stub_user_variable child_age_cutoff: 6.months.from_now

  test '#index filters' do
    visit attendees_path

    within('.filter_form') do
      assert_text 'Student number'
      assert_text 'First name'
      assert_text 'Last name'
      assert_text 'Birthdate'
      assert_text 'Email'
      assert_text 'Phone'
      assert_text 'Emergency contact'
      assert_text 'Department'
      assert_text 'Ministry'
      assert_text 'Courses'
      assert_text 'Requested Arrival date'
      assert_text 'Requested Departure date'
      assert_text 'Created at'
      assert_text 'Updated at'
    end
  end

  test '#index columns' do
    visit attendees_path

    assert_index_columns :selectable, :student_number, :first_name, :last_name,
                         :family, :birthdate, :age, :gender, :email, :phone,
                         :emergency_contact, :department, :arrived_at,
                         :departed_at, :created_at, :updated_at, :actions
  end

  test '#index items' do
    visit attendees_path

    within('#index_table_attendees') do
      assert_selector "#attendee_#{@attendee.id}"
    end
  end
end
