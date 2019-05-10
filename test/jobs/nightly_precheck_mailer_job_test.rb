require 'test_helper'

class NightlyPrecheckMailerJobTest < JobTestCase
  setup do
    @pending_family = create(:family, precheck_status: :pending_approval)
    create(:family, precheck_status: :changes_requested)
    create(:family, precheck_status: :approved)
  end

  test 'queues the expected mail' do
    PrecheckEligibilityService.stubs(:new).returns(stub(call: true))
    NightlyPrecheckMailerJob.new.perform
    assert_equal ['PrecheckMailer', 'confirm_charges', 'deliver_now', { '_aj_globalid' => "gid://cru-conference/Family/#{@pending_family.id}" }], enqueued_jobs.last[:args]
  end

  test 'only mail families in the pending approval state' do
    PrecheckEligibilityService.stubs(:new).returns(stub(call: true))
    assert_equal 3, Family.count
    assert_equal 0, enqueued_jobs.size
    NightlyPrecheckMailerJob.new.perform
    assert_equal 1, enqueued_jobs.size
    assert_equal ['PrecheckMailer', 'confirm_charges', 'deliver_now', { '_aj_globalid' => "gid://cru-conference/Family/#{@pending_family.id}" }], enqueued_jobs.last[:args]
  end

  test 'skip families that are not precheck eligible and have no reportable_errors' do
    PrecheckEligibilityService.stubs(:new).returns(stub(call: false, reportable_errors: []))
    NightlyPrecheckMailerJob.new.perform
    assert_equal 0, enqueued_jobs.size
  end

  test 'mail families that are not precheck eligible but have reportable_errors' do
    PrecheckEligibilityService.stubs(:new).returns(stub(call: false, reportable_errors: [:test_error]))
    NightlyPrecheckMailerJob.new.perform
    assert_equal 1, enqueued_jobs.size
  end
end
