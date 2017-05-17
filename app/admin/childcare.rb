ActiveAdmin.register Childcare do
  partial_view :index, :show, :form
  permit_params :name, :teachers, :location, :room
end
