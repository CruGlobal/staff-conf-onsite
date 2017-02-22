ActiveAdmin.register HousingFacility do
  extend Rails.application.helpers

  permit_params :name, :housing_type, :cost_code_id, :cafeteria, :street,
                :city, :state, :country_code, :zip

  index do
    selectable_column
    column :id
    column :name
    column(:housing_type) { |hf| hf.housing_type.titleize }
    column :cost_code
    column :cafeteria
    column :street
    column :city
    column :state
    column(:country_code) { |hf| country_name(hf.country_code) }
    column :zip
    column 'Units' do |hf|
      link_to hf.housing_units.count, housing_facility_housing_units_path(hf)
    end
    column :created_at
    column :updated_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row(:housing_type) { |hf| hf.housing_type.titleize }
      row(:cost_code) { |hf| link_to(hf.cost_code, hf.cost_code) if hf.cost_code }
      row :cafeteria
      row :city
      row :state
      row :street
      row(:country_code) { |hf| country_name(hf.country_code) }
      row :zip
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    show_errors_if_any(f)

    f.inputs do
      f.input :name
      f.input :housing_type
      f.input :cost_code, as: :select, collection: cost_code_select
      f.input :cafeteria
    end

    f.inputs 'Address' do
      f.input :street
      f.input :city
      f.input :state
      f.input :zip
      f.input :country_code, as: :select, collection: country_select
    end
    f.actions
  end

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

  sidebar 'Units', only: [:show, :edit] do
    h4 strong link_to('All Units',
                      housing_facility_housing_units_path(housing_facility))
    h4 strong 'Recently Changed'

    ul do
      housing_facility.housing_units.order(updated_at: :desc).map do |r|
        li link_to(r.name,
                   housing_facility_housing_unit_path(housing_facility, r.id))
      end
    end
  end

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
