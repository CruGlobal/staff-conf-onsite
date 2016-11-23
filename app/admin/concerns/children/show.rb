module Children
  module Show
    include People::ShowCostAdjustments
    include People::ShowMealExemptions

    def self.included(base)
      base.send :show do
        columns do
          column do
            instance_exec(&AttributesTable)
          end

          column do
            instance_exec(child, &CostAdjustmentsPanel)
            instance_exec(child, &MealExemptionsPanel)
          end
        end

        active_admin_comments
      end
    end

    AttributesTable = proc do
      attributes_table do
        row :id
        row :first_name
        row(:last_name) { |c| link_to last_name_label(c), family_path(c.family) }
        row(:gender) { |c| gender_name(c.gender) }
        row :birthdate
        row('Age', sortable: :birthdate) { |c| age(c.birthdate) }
        row :grade_level
        row(:childcare_weeks) { |c| childcare_weeks_list(c) }
        row :parent_pickup
        row :needs_bed
        row :created_at
        row :updated_at
      end
    end
  end
end
