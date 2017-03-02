class Conference::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :name
      money_input_widget(model, :price)
      input :description, as: :ckeditor
      datepicker_input(model, :start_at)
      datepicker_input(model, :end_at)
    end

    actions
  end
end
