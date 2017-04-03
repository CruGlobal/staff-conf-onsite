class UserVariable::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input_code
      input_value_type
      input_value
      input :description, as: :ckeditor
    end

    actions
  end

  private

  def input_code
    if new_record? || policy.create?
      input :code
      input :short_name, as: :hidden, input_html: { value: SecureRandom.uuid }
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
    new_record? ? input_value_for_new_record : input_value_for_existing
  end

  # Create every input widget and select the right one with Javascript
  def input_value_for_new_record
    opts = {
      label: human_attribute_name(:value),
      input_html: { value: '' },
      wrapper_html: { class: 'js-value-input' }
    }

    input :value_money,
          opts.merge(as: :string, input_html: { value: '',
                                                'data-money-input' => true })
    input :value_date,
          opts.merge(as: :datepicker, datepicker_options: {
                       changeYear: true, changeMonth: true, yearRange: 'c-80:c+10'
                     })
    input :value_number, opts.merge(as: :number)
    input :value_html, opts.merge(as: :ckeditor)
    input :value_string, opts.merge(as: :string)
  end

  def input_value_for_existing
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
