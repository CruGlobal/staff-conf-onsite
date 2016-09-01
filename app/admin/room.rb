ActiveAdmin.register Room do
  belongs_to :housing_facility

  permit_params :number

  index title: -> { "#{@housing_facility.name}: Rooms" } do
    column :id
    column(:number) { |r| h4 r.number }
    column :created_at
    column :updated_at
    actions
  end

  show title: ->(r) { "#{r.housing_facility.name}: Room #{r.number}" }

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :number
    end

    f.actions
  end

  sidebar 'Housing Facility' do
    h4 strong link_to(housing_facility.name, housing_facility_path(housing_facility))
  end
end
