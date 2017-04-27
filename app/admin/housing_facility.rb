ActiveAdmin.register HousingFacility do
  extend Rails.application.helpers

  page_cells do |page|
    page.index
    page.show
    page.form
    page.sidebar 'Units', only: [:show, :edit]
  end

  permit_params :name, :housing_type, :cost_code_id, :cafeteria, :street,
                :city, :state, :country_code, :zip, :on_campus

  filter :name
  filter :cost_code
  filter :cafeteria
  filter :on_campus
  filter :street
  filter :city
  filter :state
  filter :country_code, as: :select, collection: country_select
  filter :zip
  filter :created_at
  filter :updated_at

  action_item :import_rooms, only: :index do
    link_to 'Import Spreadsheet', action: :new_spreadsheet
  end

  collection_action :new_spreadsheet, title: 'Import Spreadsheet'
  collection_action :import_spreadsheet, method: :post do
    res =
      ImportHousingUnitsSpreadsheet.call(
        ActionController::Parameters.new(params).
          require('import_spreadsheet').permit(:file, :skip_first)
      )

    if res.success?
      redirect_to housing_facilities_path,
                  notice: 'Housing Units imported successfully.'
    else
      redirect_to new_spreadsheet_housing_facilities_path, flash: { error: res.message }
    end
  end

  controller do
    rescue_from ActiveRecord::DeleteRestrictionError,
                with: :redirect_delete_restriction

    private

    def redirect_delete_restriction(_exception)
      redirect_to housing_facility_path(params[:id]),
                  alert: 'Could not delete this Facility because people are' \
                         ' currently assigned to it.'
    end
  end
end
