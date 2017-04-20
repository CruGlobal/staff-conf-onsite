class HousingUnit::IndexCell < ::IndexCell
  def show
    selectable_column

    column :name
    column :occupancy_type
    column :room_type
    column :created_at
    column :updated_at

    actions
  end
end
