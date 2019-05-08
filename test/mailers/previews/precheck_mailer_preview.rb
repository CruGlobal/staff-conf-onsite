# Preview all emails at http://localhost:3000/rails/mailers/precheck_mailer/confirm_charges
class PrecheckMailerPreview < ActionMailer::Preview
  def confirm_charges_preview
    family = Family.first
    PrecheckMailer.confirm_charges(family)
  end
end
