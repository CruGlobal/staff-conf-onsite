ActiveAdmin.register UserVariable do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  permit_params :code, :short_name, :value_type, :value, :description

  filter :code
  filter :value_type
  filter :created_at
  filter :updated_at
end
