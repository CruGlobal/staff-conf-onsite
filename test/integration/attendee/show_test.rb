require 'test_helper'

class Attendee::ShowTest < IntegrationTest
  before do
    @user = create_login_user
    @attendee = create :attendee
  end

  stub_user_variable child_age_cutoff: 6.months.from_now,
                     rec_center_daily: Money.new(1_00)

  test '#show details' do
    visit attendee_path(@attendee)

    assert_selector '#page_title', text: @attendee.full_name
    assert_show_rows :id, :student_number, :first_name, :last_name, :family,
                     :birthdate, :age, :gender, :email, :phone, :emergency_contact,
                     :ministry, :department, :created_at, :updated_at,
                     :rec_center_pass_started_at, :rec_center_pass_expired_at,
                     selector: "#attributes_table_attendee_#{@attendee.id}"

    assert_active_admin_comments
  end

  test '#show conferences when empty' do
    visit attendee_path(@attendee)
    within('.conferences.panel') { assert_text 'None' }
  end

  test '#show conferences' do
    @conference = create :conference, attendees: [@attendee]
    visit attendee_path(@attendee)
    within('.conferences.panel') { assert_text @conference.name }
  end

  test '#show cost_adjustments when empty' do
    visit attendee_path(@attendee)
    within('.cost_adjustments.panel') { assert_text 'None' }
  end

  test '#show cost_adjustments' do
    @cost_adjustment = create :cost_adjustment, person: @attendee, cost_type: :tuition_mpd
    visit attendee_path(@attendee)
    within('.cost_adjustments.panel') { assert_text 'MPD Tuition' }
  end

  test '#show attendances when empty' do
    visit attendee_path(@attendee)
    within('.attendances.panel') { assert_text 'None' }
  end

  test '#show attendances' do
    @course = create :course, attendees: [@attendee]
    visit attendee_path(@attendee)
    within('.attendances.panel') { assert_text @course.name }
  end

  test '#show housing_assignments' do
    @stay = create :stay, person: @attendee
    visit attendee_path(@attendee)
    within('.stays.panel') { assert_text @stay.housing_unit.name }
  end
end
