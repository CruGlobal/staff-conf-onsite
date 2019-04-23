require 'test_helper'

require_relative '../../../db/user_variables'

class Family::IndexTest < IntegrationTest
  before do
    SeedUserVariables.new.call
    @user = create_login_user
    @family = create :family_with_members
  end

  test '#index page loads successfully' do
    enable_javascript!
    login_user(@user)

    visit families_path

    assert_text @family.to_s
  end
end
