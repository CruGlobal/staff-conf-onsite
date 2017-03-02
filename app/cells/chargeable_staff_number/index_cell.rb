class ChargeableStaffNumber::IndexCell < ::IndexCell
  def show
    selectable_column

    column :staff_number
    column :created_at

    actions
  end
end
