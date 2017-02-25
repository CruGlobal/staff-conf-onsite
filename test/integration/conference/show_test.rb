require 'test_helper'

class Conference::ShowTest < IntegrationTest
  before do
    @user = create_login_user
    @conference = create :conference
  end

  test '#show details' do
    visit conference_path(@conference)

    assert_selector '#page_title', text: @conference.name
    assert_show_rows :id, :name, :price, :description, :start_at, :end_at,
                     :created_at, :updated_at
    assert_active_admin_comments
  end

  test '#show attendees when empty' do
    visit conference_path(@conference)

    within('.attendees.panel') { assert_text 'None' }
  end

  test '#show attendees' do
    @attendee = create :attendee
    @conference.attendees << @attendee
    @conference.save!

    visit conference_path(@conference)

    within('.attendees.panel') { assert_text @attendee.full_name }
  end
end
