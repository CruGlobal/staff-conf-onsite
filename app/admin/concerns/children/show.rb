module Children
  module Show
    include People::ShowMealExemptions

    def self.included(base)
      base.send :show do
        columns do
          column do
            instance_exec(&AttributesTable)
          end

          column do
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
        row(:last_name) do |c|
          link_to c.last_name, family_path(c.family) if c.family_id
        end
        row(:gender) { |c| gender_name(c.gender) }
        row :birthdate
        row('Age', sortable: :birthdate) { |c| age(c.birthdate) }
        row :grade_level
        row :childcare_weeks
        row :parent_pickup
        row :needs_bed
        row :created_at
        row :updated_at
      end
    end
  end
end
