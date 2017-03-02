ActiveAdmin.register CostAdjustment do
  page_cells do |page|
    page.index
    page.show title: ->(ca) { "Cost Adjustment ##{ca.id}, for #{ca.person.full_name}" }
    page.form
  end

  permit_params :person_id, :cost_type, :price, :percent, :description

  filter :person
  filter :description
  filter :created_at
  filter :updated_at
end
