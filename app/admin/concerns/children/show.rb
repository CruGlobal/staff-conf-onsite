module Children
  # Defines the HTML for rendering a single {Child} record.
  module Show
    include People::ShowCostAdjustments
    include People::ShowMealExemptions

    def self.included(base)
      base.send :show do
        columns do
          column do
            instance_exec(&ATTRIBUTES_TABLE)
          end

          column do
            instance_exec(child, &COST_ADJUSTMENTS_PANEL)
            instance_exec(child, &MEAL_EXEMPTIONS_PANEL)
          end
        end

        active_admin_comments
      end
    end

    ATTRIBUTES_TABLE ||= proc do
      attributes_table do
        row :id
        row :first_name
        row :last_name
        row(:family) { |c| link_to family_label(c.family), family_path(c.family) }
        row(:gender) { |c| gender_name(c.gender) }
        row :birthdate
        row(:age, sortable: :birthdate) { |c| age_label(c) }
        row(:grade_level) { |c| grade_level_label(c) }
        row :childcare
        row(:childcare_weeks) { |c| childcare_weeks_list(c) }
        row :parent_pickup
        row :needs_bed
        row :created_at
        row :updated_at
      end
    end
  end
end
