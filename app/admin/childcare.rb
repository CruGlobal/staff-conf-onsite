ActiveAdmin.register Childcare do
  partial_view :index, :show, :form
  permit_params :name, :teachers, :location, :room

  filter :name
  filter :location
  filter :room
  filter :created_at
  filter :updated_at

  sidebar 'Sign-In Sheets', only: :show do
    ul do
      li { link_to 'Portrait (PDF)', action: :signin_portrait }
      li { link_to 'Landscape (PDF)', action: :signin_landscape }
    end
  end

  sidebar 'Rosters', only: :show do
    ul do
      Childcare::CHILDCARE_WEEKS.each_with_index do |name, index|
        li { link_to "#{name} (PDF)", action: :roster, week: index }
      end
    end
  end

  sidebar 'Sign-In Sheets', only: :index do
    ul do
      li { link_to 'Portrait (PDF)', params.merge(action: :signin_portraits) }
      li { link_to 'Landscape (PDF)', params.merge(action: :signin_landscapes) }
    end
  end

  sidebar 'Rosters', only: :index do
    ul do
      Childcare::CHILDCARE_WEEKS.each_with_index do |name, index|
        li do
          link_to "#{name} (PDF)", params.merge(action: :rosters, week: index)
        end
      end
    end
  end

  collection_action :rosters do
    week = params[:week]&.to_i
    if Childcare::CHILDCARE_WEEKS.size.times.to_a.include?(week)
      roster = AggregatePdfService.call(Childcare::Roster, collection,
                                        key: :childcare, week: week,
                                        author: current_user)
      send_data(roster.render, type: 'application/pdf', disposition: :inline)
    else
      redirect_to childcares_path,
                  alert: format('Invalid week of childcare %p', week)
    end
  end

  collection_action :signin_portraits do
    roster = AggregatePdfService.call(Childcare::Signin::Portrait, collection,
                                      key: :childcare, author: current_user)
    send_data(roster.render, type: 'application/pdf', disposition: :inline)
  end

  collection_action :signin_landscapes do
    roster = AggregatePdfService.call(Childcare::Signin::Landscape, collection,
                                      key: :childcare, author: current_user)
    send_data(roster.render, type: 'application/pdf', disposition: :inline)
  end

  member_action :signin_portrait do
    roster =
      Childcare::Signin::Portrait.call(childcare: Childcare.find(params[:id]),
                                       author: current_user)

    send_data(roster.render, type: 'application/pdf', disposition: :inline)
  end

  member_action :signin_landscape do
    roster =
      Childcare::Signin::Landscape.call(childcare: Childcare.find(params[:id]),
                                        author: current_user)

    send_data(roster.render, type: 'application/pdf', disposition: :inline)
  end

  member_action :roster do
    week = params[:week]&.to_i
    if Childcare::CHILDCARE_WEEKS.size.times.to_a.include?(week)
      roster = Childcare::Roster.call(record: Childcare.find(params[:id]),
                                      week: week, author: current_user)

      send_data(roster.render, type: 'application/pdf', disposition: :inline)
    else
      redirect_to childcare_path(params[:id]),
                  alert: format('Invalid week of childcare %p', week)
    end
  end
end
