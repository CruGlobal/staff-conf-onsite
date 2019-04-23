require 'test_helper'

require_relative '../../../db/user_variables'

class Family::SummaryTest < IntegrationTest
  before do
    SeedUserVariables.new.call
    @user = create_login_user
    @family = create :family
    @attendee = create :attendee, family: @family
    @child = create :child, family: @family
  end

  test '#summary page loads successfully' do
    enable_javascript!
    login_user(@user)

    visit summary_family_path(@family.id)

    assert_text @child.full_name
    assert_text @attendee.full_name
  end
end
