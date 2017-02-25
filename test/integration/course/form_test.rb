require 'test_helper'

class Course::FormTest < IntegrationTest
  before do
    @user = create_login_user
    @course = create :course
  end

  test '#edit fields' do
    visit edit_course_path(@course)

    assert_edit_fields :name, :instructor, :price, :description,
                       :week_descriptor, :ibs_code, :location,
                       record: @course

    assert_active_admin_comments
  end
end
