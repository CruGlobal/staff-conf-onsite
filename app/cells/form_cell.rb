class FormCell < ShowCell
  property :form,
           :has_many,
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

  def actions
    super
    # The reason to return nil here is to avoid rending the action buttons
    # twice. Arbre inserts HTML into a Arbre::Context, but also returns the
    # HTML from method call. Also, if a cell returns a string, it will be
    # appended to the page a second time.
    nil
  end
end
