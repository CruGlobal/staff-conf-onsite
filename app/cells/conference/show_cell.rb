class Conference::ShowCell < ::ShowCell
  property :conference

  def show
    columns do
      column { conference_attributes_table }
      column { attendees_panel }
    end

    active_admin_comments
  end

  private

  def conference_attributes_table
    attributes_table do
      row :name
      row(:price) { |c| humanized_money_with_symbol(c.price) }
      row(:description) { |c| c.description.try(:html_safe) }
      row :start_at
      row :end_at
      row :waive_off_campus_facility_fee
      row :created_at
      row :updated_at
    end
  end

  def attendees_panel
    size = conference.attendees.size

    panel "Attendees (#{size})", class: 'attendees' do
      size.positive? ? attendees_list : strong('None')
    end
  end

  def attendees_list
    ul do
      conference.attendees.each do |a|
        li { link_to(a.full_name, a) }
      end
    end
  end
end
