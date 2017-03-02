class CostCode::IndexCell < ::IndexCell
  def show
    selectable_column

    column :id
    column :name
    column(:description) { |c| html_summary(c.description) }
    column :min_days
    column :created_at
    column :updated_at

    actions
  end
end
