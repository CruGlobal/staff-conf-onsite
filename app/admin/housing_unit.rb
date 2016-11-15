ActiveAdmin.register HousingUnit do
  belongs_to :housing_facility

  permit_params :name

  index title: -> { "#{@housing_facility.name}: Units" } do
    column :id
    column(:name) { |r| h4 r.name }
    column :created_at
    column :updated_at
    actions
  end

  show title: ->(r) { "#{r.housing_facility.name}: Units #{r.name}" }

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :name
    end

    f.actions
  end

  sidebar 'Housing Facility' do
    h4 strong link_to(housing_facility.name, housing_facility_path(housing_facility))
  end
end
