class CostCode::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column :name
    column(:description) { |c| html_summary(c.description) }
    column :min_days
    column :created_at
    column :updated_at
  end
end
