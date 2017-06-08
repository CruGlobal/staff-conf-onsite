ActiveAdmin.register Childcare do
  partial_view :index, :show, :form
  permit_params :name, :teachers, :location, :room

  filter :name
  filter :location
  filter :room
  filter :created_at
  filter :updated_at

  action_item :roster, only: :show do
    link_to 'Roster (PDF)', action: :roster
  end

  member_action :roster do
    roster = Childcare::Roster.call(childcare: Childcare.find(params[:id]),
                                    date: Time.zone.today, author: current_user)

    send_data(
      roster.render,
      type: 'application/pdf',
      disposition: :inline
    )
  end
end
