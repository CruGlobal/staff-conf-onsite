class Childcare::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column :name
    column :teachers
    column :location
    column :room
    column :created_at
    column :updated_at
  end
end
