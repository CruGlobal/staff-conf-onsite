ActiveAdmin.register HousingUnit do
  page_cells do |page|
    page.show title: ->(r) { "#{r.housing_facility.name}: Unit #{r.name}" }
  end

  belongs_to :housing_facility

  permit_params :name

  index title: -> { "#{@housing_facility.name}: Units" } do
    column :id
    column(:name) { |r| h4 r.name }
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    show_errors_if_any(f)

    f.inputs do
      f.input :name
    end

    f.actions
  end

  sidebar 'Housing Facility' do
    h4 strong link_to(housing_facility.name, housing_facility_path(housing_facility))
  end

  action_item :import_rooms, only: :index do
    link_to 'Import Spreadsheet',
            new_spreadsheet_housing_facility_path(params[:housing_facility_id])
  end
end
