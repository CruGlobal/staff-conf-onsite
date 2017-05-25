ActiveAdmin.register Payment do
  partial_view :index, :show, :form

  permit_params :family_id, :cost_type, :price, :business_unit,
                :operating_unit, :department_id, :project_id, :reference
end
