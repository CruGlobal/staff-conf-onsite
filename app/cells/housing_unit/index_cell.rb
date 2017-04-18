class HousingUnit::IndexCell < ::IndexCell
  def show
    selectable_column

    column :name
    column :created_at
    column :updated_at

    actions
  end
end
