class FormCell < ShowCell
  property :form,
           :has_many,
           :input,
           :inputs,
           :object,
           :semantic_fields_for

  delegates :object, :new_record?

  protected

  # If the form contains any errors (from the user's last POST), display those
  # errors in a list.
  def show_errors_if_any
    model.semantic_errors(*object.errors.keys)
  end
end
