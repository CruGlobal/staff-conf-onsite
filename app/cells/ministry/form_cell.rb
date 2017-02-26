class Ministry::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :code
      input :name
      select_ministry_widget(model, :parent)
    end

    actions
  end
end
