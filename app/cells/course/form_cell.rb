class Course::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :name
      input :instructor
      money_input_widget(model, :price)
      input :description
      input :week_descriptor
      input :ibs_code
      input :location
    end

    actions
  end
end
