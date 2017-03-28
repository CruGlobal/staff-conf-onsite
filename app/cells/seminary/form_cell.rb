class Seminary::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :name
      input :code
      money_input_widget(model, :course_price)
    end

    actions
  end
end
