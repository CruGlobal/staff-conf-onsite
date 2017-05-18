ActiveAdmin.register Conference do
  partial_view :index, :show, :form
  permit_params :name, :description, :start_at, :end_at, :price,
                :waive_off_campus_facility_fee

  filter :name
  filter :description
  filter :start_at
  filter :end_at
  filter :created_at
  filter :updated_at
end
