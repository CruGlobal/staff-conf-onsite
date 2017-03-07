class UserVariable::IndexCell < ::IndexCell
  def show
    selectable_column
    id_column

    column :code
    column(:type) { |var| user_variable_type(var) }
    column(:value) { |var| user_variable_label(var) }
    column(:description) { |var| html_summary(var.description) }
    column :updated_at

    actions
  end
end
