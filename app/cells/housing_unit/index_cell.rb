class HousingUnit::IndexCell < ::IndexCell
  def show
    column :id
    column :name
    column :created_at
    column :updated_at
    actions
  end
end
