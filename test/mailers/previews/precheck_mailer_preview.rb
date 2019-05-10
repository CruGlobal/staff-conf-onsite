# Preview all emails at http://localhost:3000/rails/mailers/precheck_mailer/confirm_charges
class PrecheckMailerPreview < ActionMailer::Preview
  def confirm_charges_preview
    family = Family.first
    PrecheckMailer.confirm_charges(family)
  end

  def changes_requested_preview
    family = Family.first
    message = 'Please spell my name correctly!'
    PrecheckMailer.changes_requested(family, message)
  end

  def report_issues_preview
    family = Family.first
    PrecheckMailer.report_issues(family)
  end
end
