ActiveAdmin.register Family do
  extend Rails.application.helpers

  page_cells do |page|
    page.index
    page.show title: ->(f) { family_label(f) }
    page.form title: ->(f) { f.new_record? ? 'New Family' : "Edit #{family_label(f)}" }
    page.sidebar 'Family Members', only: [:edit]
  end

  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :address1, :address2, :city, :state,
                :zip, :country_code, :registration_comment,
                housing_preference_attributes: [
                  :id, :housing_type, :roommates, :beds_count, :single_room,
                  :children_count, :bedrooms_count, :other_family,
                  :accepts_non_air_conditioned, :location1, :location2,
                  :location3, :confirmed_at, :comment
                ]

  filter :last_name_or_people_first_name_cont, label: 'Last Name or Family Member Name'
  filter :address1
  filter :address2
  filter :city
  filter :state
  filter :country_code, as: :select, collection: country_select
  filter :zip
  filter :registration_comment
  filter :created_at
  filter :updated_at

  collection_action :new_spreadsheet, title: 'Import Spreadsheet'
  action_item :import_spreadsheet, only: :index do
    link_to 'Import Spreadsheet', action: :new_spreadsheet
  end

  collection_action :import_spreadsheet, method: :post do
    res =
      Import::ImportPeopleFromSpreadsheet.call(
        ActionController::Parameters.new(params).
          require(:import_spreadsheet).permit(:file)
      )

    if res.success?
      redirect_to families_path, notice: 'People imported successfully.'
    else
      redirect_to new_spreadsheet_families_path, flash: { error: res.message }
    end
  end
end
