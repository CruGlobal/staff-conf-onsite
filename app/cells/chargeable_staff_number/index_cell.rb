class ChargeableStaffNumber::IndexCell < ::IndexCell
  def show
    actions
    selectable_column

    column :staff_number
    column :created_at
  end
end
