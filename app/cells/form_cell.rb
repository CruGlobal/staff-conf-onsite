class FormCell < ShowCell
  property :has_many,
           :input,
           :inputs,
           :object,
           :semantic_fields_for

  protected

  # If the form contains any errors (from the user's last POST), display those
  # errors in a list.
  def show_errors_if_any
    model.semantic_errors(*object.errors.keys)
  end

  def submit_buttons
    fieldset class: 'actions' do
      ol do
        li { model.action(:submit) }
        li { model.cancel_link }
      end
    end
  end
end
