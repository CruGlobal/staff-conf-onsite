class ChargeableStaffNumber::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :staff_number
    end

    actions
  end
end
