ActiveAdmin.register HousingUnit do
  page_cells do |page|
    page.index title: -> { "#{@housing_facility.name}: Units" }
    page.show title: ->(hu) { "#{hu.housing_facility.name}: Unit #{hu.name}" }
    page.form
    page.sidebar 'Housing Facility'
  end

  config.sort_order = 'name_asc'

  belongs_to :housing_facility

  permit_params :name

  action_item :import_rooms, only: :index do
    link_to 'Import Spreadsheet',
            new_spreadsheet_housing_facility_path(params[:housing_facility_id])
  end
end
