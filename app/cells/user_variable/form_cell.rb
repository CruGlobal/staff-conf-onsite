class UserVariable::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input_code
      input_value_type
      input_value
      input :description, as: :ckeditor

      input :short_name, as: :hidden if new_record?
    end

    actions
  end

  private

  def input_code
    if new_record? || policy.create?
      input :code
    else
      input :code, as: :string, input_html: { readonly: true }
    end
  end

  def input_value_type
    if new_record? || policy.create?
      input :value_type
    else
      input :value_type, as: :string, input_html: {
        readonly: true, value: user_variable_type(object)
      }
    end
  end

  def input_value
    case object.value_type
    when 'money'
      money_input_widget(model, :value)
    when 'date'
      datepicker_input(model, :value)
    when 'number'
      input :value, as: :number
    when 'html'
      input :value, as: :ckeditor
    else
      input :value
    end
  end
end
