require 'test_helper'

class Course::FormTest < IntegrationTest
  setup do    
    @user = create_login_user
    @course = create :course
  end

  test '#edit fields' do
    visit edit_course_path(@course)

    assert_edit_fields :name, :instructor, :price, :description,
                       :week_descriptor, :ibs_code, :location,
                       record: @course
  end

  test '#new record creation' do
    attr = attributes_for :course

    visit new_course_path

    assert_difference 'Course.count' do
      within('form#new_course') do
        fill_in 'Name',            with: attr[:name]
        fill_in 'Instructor',      with: attr[:instructor]
        fill_in 'Description',     with: attr[:description]
        fill_in 'Week descriptor', with: attr[:week_descriptor]
        fill_in 'IBS ID',          with: attr[:ibs_code]
        fill_in 'Location',        with: attr[:location]        
        fill_in 'Price',           with: attr[:price].to_f.to_s
      end

      click_button 'Create Class'
    end
  end
end
