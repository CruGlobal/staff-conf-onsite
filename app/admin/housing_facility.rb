ActiveAdmin.register HousingFacility do
  extend Rails.application.helpers

  page_cells do |page|
    page.index
    page.show
    page.form
    page.sidebar 'Units', only: [:show, :edit]
  end

  permit_params :name, :housing_type, :cost_code_id, :cafeteria, :street,
                :city, :state, :country_code, :zip, :on_campus, :csu_dorm_code,
                :csu_dorm_block

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
    if authorized?(:import, HousingFacility)
      link_to 'Import Spreadsheet', action: :new_spreadsheet
    end
  end

  collection_action :new_spreadsheet, title: 'Import Spreadsheet'
  collection_action :import_spreadsheet, method: :post do
    return head :forbidden unless authorized?(:import, HousingFacility)

    import_params =
      ActionController::Parameters.new(params).require('import_spreadsheet').
        permit(:file, :skip_first)

    job = UploadJob.create_with_copy!(user_id: current_user.id,
                                      path: import_params[:file].path)
    ImportHousingUnitsSpreadsheetJob.perform_later(job.id,
                                                   import_params[:skip_first])

    respond_to do |format|
      format.html { redirect_to housing_facility_path, notice: 'Upload Started' }
      format.json { render json: job }
    end
  end

  controller do
    rescue_from ActiveRecord::DeleteRestrictionError, with: :delete_restriction

    private

    def delete_restriction(_exception)
      msg = 'Could not delete this Facility because people are assigned to it.'
      redirect_to housing_facility_path(params[:id]), alert: msg
    end
  end
end
