require 'test_helper'

class NightlyPrecheckMailerJobTest < JobTestCase
  setup do
    @pending_family = create(:family, precheck_status: :pending_approval)
    create(:family, precheck_status: :changes_requested)
    create(:family, precheck_status: :approved)
  end

  test 'queues the expected mail' do
    Precheck::EligibilityService.stubs(:new).returns(stub(call: true, too_late_or_checked_in?: false))
    NightlyPrecheckMailerJob.new.perform
    assert_equal ['PrecheckMailer', 'confirm_charges', 'deliver_now', { '_aj_globalid' => "gid://cru-conference/Family/#{@pending_family.id}" }], enqueued_jobs.last[:args]
  end

  test 'only mail families in the pending approval state' do
    Precheck::EligibilityService.stubs(:new).returns(stub(call: true, too_late_or_checked_in?: false))
    assert_equal 3, Family.count
    assert_equal 0, enqueued_jobs.size
    NightlyPrecheckMailerJob.new.perform
    assert_equal 1, enqueued_jobs.size
    assert_equal ['PrecheckMailer', 'confirm_charges', 'deliver_now', { '_aj_globalid' => "gid://cru-conference/Family/#{@pending_family.id}" }], enqueued_jobs.last[:args]
  end

  test 'skip families that are not precheck eligible and have no actionable_errors' do
    Precheck::EligibilityService.stubs(:new).returns(stub(call: false, actionable_errors: [], too_late_or_checked_in?: false))
    NightlyPrecheckMailerJob.new.perform
    assert_equal 0, enqueued_jobs.size
  end

  test 'mail families that are not precheck eligible but have actionable_errors' do
    Precheck::EligibilityService.stubs(:new).returns(stub(call: false, actionable_errors: [:test_error], too_late_or_checked_in?: false))
    NightlyPrecheckMailerJob.new.perform
    assert_equal 1, enqueued_jobs.size
  end

  test 'skip families that are too late or checked in but are still precheck pending' do
    Precheck::EligibilityService.stubs(:new).returns(stub(call: true, too_late_or_checked_in?: true))
    NightlyPrecheckMailerJob.new.perform
    assert_equal 0, enqueued_jobs.size
  end
end
