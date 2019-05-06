require 'test_helper'

require_relative '../../db/user_variables'

class TestMailer < ApplicationMailer
  def test(attributes)
    mail(attributes) do |format|
      format.html { render text: 'Test' }
    end
  end
end

class MailInterceptorTest < MailTestCase
  setup do
    SeedUserVariables.new.call
  end

  test 'intercepting addresses take the place of recipients' do
    email = TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
    assert_equal ['interceptor_one@example.com', 'interceptor_two@example.com'], email.to
  end

  test 'intercepting clears copy' do
    email = TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
    assert_equal [], email.cc
  end

  test 'intercepting clears blind copy' do
    UserVariable.find_by(short_name: :mail_bcc_email_addresses).delete

    email = TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
    assert_equal [], email.bcc
  end

  test 'no variables set' do
    MailInterceptor.stub :force_interception?, false do
      UserVariable.find_by(short_name: :mail_interceptor_email_addresses).delete
      UserVariable.find_by(short_name: :mail_bcc_email_addresses).delete

      email = TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
      assert_equal ['to@example.com'], email.to
      assert_equal ['copy@example.com'], email.cc
      assert_equal ['blind@example.com'], email.bcc
    end
  end

  test 'no interceptor set, but bcc email addresses are set' do
    MailInterceptor.stub :force_interception?, false do
      UserVariable.find_by(short_name: :mail_interceptor_email_addresses).delete

      email = TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
      assert_equal ['blind@example.com', 'blind_copy_one@example.com', 'blind_copy_two@example.com'], email.bcc
    end
  end

  test 'force intercepting, without variables set' do
    UserVariable.find_by(short_name: :mail_interceptor_email_addresses).delete
    UserVariable.find_by(short_name: :mail_bcc_email_addresses).delete

    MailInterceptor.stub :force_interception?, true do
      assert_raises RuntimeError do
        TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
      end
    end
  end

  test 'force intercepting, with variables set' do
    MailInterceptor.stub :force_interception?, true do
      email = TestMailer.test(to: 'to@example.com', cc: 'copy@example.com', bcc: 'blind@example.com').deliver_now
      assert_equal ['interceptor_one@example.com', 'interceptor_two@example.com'], email.to
      assert_equal [], email.cc
      assert_equal ['blind_copy_one@example.com', 'blind_copy_two@example.com'], email.bcc
    end
  end
end
