class Ministry::ShowCell < ::ShowCell
  property :ministry

  def show
    columns do
      column do
        ministry_attributes_table
      end

      column do
        ministry_hierarchy if ministry.ancestors.any? || ministry.children.any?
        members_panel
      end
    end
  end

  private

  def ministry_attributes_table
    attributes_table do
      row :id
      row :code
      row :name
      row(:parent) do |m|
        link_to m.parent, m.parent if m.parent.present?
      end
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  def ministry_hierarchy
    panel 'Hierarchy', class: 'hierarchy' do
      div class: 'ministry__hierarchy' do
        ancestors_list if ministry.ancestors.any?
        div(class: 'ministry__hierarchy__this') { ministry }
        children_list if ministry.children.any?
      end
    end
  end

  def ancestors_list
    ul class: 'ministry__hierarchy__ancestors' do
      ministry.ancestors.each do |m|
        li(class: 'ministry__hierarchy__ancestor') { link_to m, m }
      end
    end
  end

  def children_list
    ul class: 'ministry__hierarchy__children' do
      ministry.children.each do |child|
        li class: 'ministry__hierarchy__child' do
          link_to child, child
        end
      end
    end
  end

  def members_panel
    num_members = ministry.people.size

    panel "Members (#{num_members})", class: 'members' do
      num_members.positive? ? members_list : strong('None')
    end
  end

  def members_list
    ul do
      ministry.people.each do |p|
        li { link_to(p.full_name, p) }
      end
    end
  end
end
