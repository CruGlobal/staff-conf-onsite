ActiveAdmin.register Conference do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  permit_params :name, :description, :start_at, :end_at, :price

  filter :name
  filter :description
  filter :start_at
  filter :end_at
  filter :created_at
  filter :updated_at
end
