class HousingUnit::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column :name
    column :occupancy_type
    column :created_at
    column :updated_at
  end
end
