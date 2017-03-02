class CostAdjustment::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :person
      input :cost_type, as: :select, collection: cost_type_select
      money_input_widget(model, :price)
      input :percent
      input :description, as: :ckeditor
    end

    actions
  end
end
