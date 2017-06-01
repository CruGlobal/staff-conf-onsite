ActiveAdmin.register Childcare do
  partial_view :index, :show, :form
  permit_params :name, :teachers, :location, :room

  filter :name
  filter :location
  filter :room
  filter :created_at
  filter :updated_at
end
