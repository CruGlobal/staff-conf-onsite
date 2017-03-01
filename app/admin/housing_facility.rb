ActiveAdmin.register HousingFacility do
  extend Rails.application.helpers

  page_cells do |page|
    page.index
    page.show
    page.form
    page.sidebar 'Units', only: [:show, :edit]
  end

  permit_params :name, :housing_type, :cost_code_id, :cafeteria, :street,
                :city, :state, :country_code, :zip

  filter :name
  filter :cost_code
  filter :cafeteria
  filter :street
  filter :city
  filter :state
  filter :country_code, as: :select, collection: country_select
  filter :zip
  filter :created_at
  filter :updated_at

  action_item :import_rooms, only: :show do
    link_to 'Import Spreadsheet', action: :new_spreadsheet
  end

  member_action :new_spreadsheet, title: 'Import Spreadsheet'
  member_action :import_spreadsheet, method: :post do
    res =
      ImportHousingUnitsSpreadsheet.call(
        ActionController::Parameters.new(params).
          require('import_spreadsheet').
          permit(:file, :skip_first, :delete_existing).reverse_merge(
            housing_facility_id: params[:id]
          )
      )

    if res.success?
      redirect_to housing_facility_path(params[:id]),
                  notice: 'Housing Units imported successfully.'
    else
      redirect_to new_spreadsheet_rooms_path, flash: { error: res.message }
    end
  end
end
