ActiveAdmin.register CostCode do
  permit_params :name, :description, :min_days, charges_attributes: [
    :id, :_destroy, :max_days, :adult, :teen, :child, :infant, :child_meal,
    :single_delta
  ]

  index do
    selectable_column
    column :id
    column :name
    column(:description) { |c| html_summary(c.description) }
    column :min_days
    column :created_at
    column :updated_at
    actions
  end

  filter :name
  filter :description
  filter :min_days
  filter :created_at
  filter :updated_at

  show do
    columns do
      column do
        attributes_table do
          row(:name) { |c| strong c.name }
          row(:description) { |c| html_summary(c.description) }
          row :min_days
          row :created_at
          row :updated_at
        end
      end

      column do
        panel 'Charges' do
          attributes_table_for cost_code.charges.order(:max_days) do
            row(:max_days) { |c| strong c.max_days }
            row(:adult) { |c| humanized_money_with_symbol(c.adult) }
            row(:teen) { |c| humanized_money_with_symbol(c.teen) }
            row(:child) { |c| humanized_money_with_symbol(c.child) }
            row(:infant) { |c| humanized_money_with_symbol(c.infant) }
            row(:child_meal) { |c| humanized_money_with_symbol(c.child_meal) }
            row(:single_delta) { |c| humanized_money_with_symbol(c.single_delta) }
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    columns do
      column do
        f.inputs do
          f.input :name
          f.input :description, as: :ckeditor
          f.input :min_days
        end
      end

      column do
        panel 'Charges' do
          f.has_many :charges, heading: nil do |cf|
            cf.input :max_days

            money_input_widget(cf, :adult)
            money_input_widget(cf, :teen)
            money_input_widget(cf, :child)
            money_input_widget(cf, :infant)
            money_input_widget(cf, :child_meal)
            money_input_widget(cf, :single_delta)

            cf.input :_destroy, as: :boolean, wrapper_html: { class: 'destroy' }
          end
        end
      end
    end

    f.actions
  end
end
