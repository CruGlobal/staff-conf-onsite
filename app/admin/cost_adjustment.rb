ActiveAdmin.register CostAdjustment do
  permit_params :person_id, :price, :description

  index do
    selectable_column
    column :id
    column('Person') { |ca| link_to(ca.person.full_name, ca.person) }
    column(:price) { |c| humanized_money_with_symbol(c.price) }
    column(:description) { |ca| html_summary(ca.description) }
    column :created_at
    column :updated_at
    actions
  end

  show title: ->(ca) { "Cost Adjustment ##{ca.id}, for #{ca.person.full_name}" } do
    attributes_table do
      row :id
      row('Person') { |ca| link_to(ca.person.full_name, ca.person) }
      row(:price) { |c| humanized_money_with_symbol(c.price) }
      row(:description) { |ca| html_summary(ca.description) }
      row :created_at
      row :updated_at
    end
  end

  filter :person
  filter :description
  filter :created_at
  filter :updated_at

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :person
      f.input :price_cents, as: :string
      f.input :description, as: :ckeditor
    end
    f.actions
  end
end
