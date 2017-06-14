ActiveAdmin.register Family do
  includes :attendees, :housing_preference

  partial_view(
    :index,
    show: { title: ->(f) { family_label(f) } },
    form: { title: ->(f) { f.new_record? ? 'New Family' : "Edit #{family_label(f)}" } },
    sidebar: ['Family Members', only: [:edit]]
  )

  menu parent: 'People', priority: 1

  permit_params :last_name, :staff_number, :address1, :address2, :city, :state,
                :zip, :country_code, :primary_person_id,
                housing_preference_attributes: [
                  :id, :housing_type, :roommates, :beds_count, :single_room,
                  :children_count, :bedrooms_count, :other_family,
                  :accepts_non_air_conditioned, :location1, :location2,
                  :location3, :confirmed_at, :comment
                ],
                people_attributes: [:id, { stays_attributes: [
                  :id, :_destroy, :housing_unit_id, :arrived_at, :departed_at,
                  :single_occupancy, :no_charge, :waive_minimum, :percentage,
                  :comment, :no_bed
                ] }]

  filter :last_name
  filter :attendees_first_name, label: 'Attendee Name', as: :string
  filter :staff_number
  filter :address1
  filter :address2
  filter :city
  filter :state
  filter :country_code, as: :select, collection: -> { country_select }
  filter :zip
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

    redirect_to job
  end

  action_item :summary, only: [:show, :edit] do
    link_to 'Summary', summary_family_path(family)
  end

  action_item :nametag, only: [:show, :edit] do
    link_to 'Nametags (PDF)', nametag_family_path(family), target: '_blank' if family.checked_in?
  end

  action_item :new_payment, only: :summary do
    link_to 'New Payment', new_family_payment_path(params[:id])
  end

  action_item :link_back, only: :summary do
    link_to 'Back to Family', action: :show
  end

  member_action :summary do
    family = Family.find(params[:id])
    finances = FamilyFinances::Report.call(family: family)

    render :summary, locals: { family: family, finances: finances }
  end

  member_action :checkin, method: :post do
    return head :forbidden unless authorized?(:checkin, Family)

    @family = Family.find(params[:id])
    @finances = FamilyFinances::Report.call(family: @family)

    if @finances.remaining_balance.zero?
      @family.check_in!
      respond_to do |format|
        format.html do
          redirect_to summary_family_path(@family.id), notice: 'Checked-in!'
        end
        format.js
      end
    else
      redirect_to summary_family_path(@family.id),
                  alert: "The family's balance must be zero to check-in."
    end
  end

  collection_action :nametags do
    applicable = collection.select(&:checked_in?)
    roster = AggregatePdfService.call(Family::Nametag, applicable,
                                      key: :family, author: current_user)
    send_data(roster.render, type: 'application/pdf', disposition: :inline)
  end

  member_action :nametag do
    roster = Family::Nametag.call(family: Family.find(params[:id]),
                                  author: current_user)

    send_data(roster.render, type: 'application/pdf', disposition: :inline)
  end

  sidebar 'Nametags', only: :index do
    link_to 'Checked-in Families (PDF)', params.merge(action: :nametags)
  end

  controller do
    def update
      update! do |format|
        format.html do
          if request.referer.include?('housing')
            redirect_to housing_path(family_id: @family.id)
          else
            redirect_to families_path
          end
        end
      end
    end
  end
end
