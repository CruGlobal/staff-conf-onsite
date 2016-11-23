module People
  module Form
    include FormMealExemptions

    FORM_OPTIONS = {
      # If creating a new family-member, show the family name in the title
      title: proc do |attendee|
        label = "#{action_name.titlecase} #{attendee.class.name}"

        if (family = attendee.family || param_family)
          "#{label} (#{family_label(family)})"
        else
          label
        end
      end
    }.freeze

    # If creating a new family-member, do not let the family association be
    # editable.
    FamilySelector = proc do |form|
      if (id = form.object.family_id || param_family.try(:id))
        form.input :family_id, as: :hidden, input_html: { value: id }
      else
        form.input :family
      end
    end
  end
end
