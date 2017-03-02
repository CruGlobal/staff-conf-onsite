class Childcare::ShowCell < ::ShowCell
  property :childcare

  def show
    columns do
      column { childcare_attributes_table }
      column { children_panel }
    end

    active_admin_comments
  end

  private

  def childcare_attributes_table
    attributes_table do
      row :id
      row :name
      row :teachers
      row :location
      row :room
      row :created_at
      row :updated_at
    end
  end

  def children_panel
    size = childcare.children.size

    panel "Children (#{size})" do
      size.positive? ? children_list : strong('None')
    end
  end

  def children_list
    ul do
      childcare.children.each do |c|
        li { link_to(c.full_name, c) }
      end
    end
  end
end
