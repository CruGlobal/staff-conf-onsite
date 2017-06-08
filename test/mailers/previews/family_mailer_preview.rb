# Preview all emails at http://localhost:3000/rails/mailers/famlily_summary
class FamilyMailerPreview < ActionMailer::Preview
  def summary
    family = Family.find_by(last_name: 'Starcher')
    FamilyMailer.summary(family)
  end
end
