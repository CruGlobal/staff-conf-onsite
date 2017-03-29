class Conference::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :name
      money_input_widget(model, :price)
      input :description
      datepicker_input(model, :start_at)
      datepicker_input(model, :end_at)
      input :waive_off_campus_facility_fee
    end

    actions
  end
end
