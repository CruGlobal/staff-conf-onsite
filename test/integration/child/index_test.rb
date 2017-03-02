require 'test_helper'

class Child::IndexTest < IntegrationTest
  before do
    @user = create_login_user
    @child = create :child
  end

  test '#index filters' do
    enable_javascript!
    login_user(@user)

    @child.update!(childcare_id: nil)
    @childcare = create :childcare

    visit children_path
    within("#child_#{@child.id}") do
      select_random('child[childcare_id]')
    end
    wait_for_ajax!

    refute_nil @child.reload.childcare_id
  end
end
