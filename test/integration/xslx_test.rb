require 'test_helper'

class XlsxTest < IntegrationTest
  before do
    @user = create_login_user
  end

  test 'Test .xlsx format' do
    visit ministries_path(format: :xlsx)
  end
end

