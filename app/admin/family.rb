ActiveAdmin.register Family do
  extend Rails.application.helpers

  partial_view(
    :index,
    show: { title: ->(f) { family_label(f) } },
    form: { title: ->(f) { f.new_record? ? 'New Family' : "Edit #{family_label(f)}" } },
    sidebar: ['Family Members', only: [:edit]]
  )

  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :address1, :address2, :city, :state,
                :zip, :country_code, :registration_comment,
                housing_preference_attributes: [
                  :id, :housing_type, :roommates, :beds_count, :single_room,
                  :children_count, :bedrooms_count, :other_family,
                  :accepts_non_air_conditioned, :location1, :location2,
                  :location3, :confirmed_at, :comment
                ]

  filter :last_name
  filter :attendees_first_name, label: 'Attendee Name', as: :string
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
    if authorized?(:import, Family)
      link_to 'Import Spreadsheet', action: :new_spreadsheet
    end
  end

  collection_action :import_spreadsheet, method: :post do
    return head :forbidden unless authorized?(:import, Family)

    import_params =
      ActionController::Parameters.new(params).require(:import_spreadsheet).
        permit(:file)

    job = UploadJob.create!(user_id: current_user.id,
                            filename: import_params[:file].path)
    ImportPeopleFromSpreadsheetJob.perform_later(job.id)

    respond_to do |format|
      format.html { redirect_to new_spreadsheet_families_path, notice: 'Upload Started' }
      format.json { render json: job }
    end
  end
end
