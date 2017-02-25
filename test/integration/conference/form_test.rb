require 'test_helper'

class Conference::FormTest < IntegrationTest
  before do
    @user = create_login_user
    @conference = create :conference
  end

  test '#edit fields' do
    visit edit_conference_path(@conference)

    assert_edit_fields :name, :price, :description, :start_at, :end_at,
                       record: @conference

    assert_active_admin_comments
  end

  test '#new object creation' do
    attr = attributes_for :conference

    visit new_conference_path

    assert_difference 'Conference.count' do
      within('form#new_conference') do
        fill_in 'Name',        with: attr[:name]
        fill_in 'Description', with: attr[:description]
        fill_in 'Start at',    with: attr[:start_at]
        fill_in 'End at',      with: attr[:end_at]
      end

      click_button 'Create Conference'
    end
  end
end
