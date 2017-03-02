class Family::SidebarCell < ::IndexCell
  property :family

  def show
    attendees_list
    children_list

    div class: 'action_items' do
      span link_to('New Attendee', new_attendee_path(family_id: family.id)), class: 'action_item'
      span link_to('New Child', new_child_path(family_id: family.id)), class: 'action_item'
    end
  end

  private

  def attendees_list
    attendees = family.attendees.load
    return unless attendees.any?

    h4 strong 'Attendees'
    ul do
      attendees.each do |p|
        li link_to(p.full_name, attendee_path(p))
      end
    end
  end

  def children_list
    children = family.children.load
    return unless children.any?

    h4 strong 'Children'
    ul do
      children.each do |p|
        li link_to(p.full_name, child_path(p))
      end
    end
  end
end
