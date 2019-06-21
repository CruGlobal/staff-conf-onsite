# Preview all emails at http://localhost:3000/rails/mailers/famlily_summary
class FamilyMailerPreview < ActionMailer::Preview
  def summary
    family = Family.first
    FamilyMailer.summary(family)
  end

  def forms_approved
    child = Child.first
    family = child.family
    FamilyMailer.forms_approved(family, family.children.first)
  end
end
