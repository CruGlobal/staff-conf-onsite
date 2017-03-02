class Childcare::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs do
      input :name, hint: 'Title of class including grade'
      input :teachers,
            hint: 'If more than one teacher please use commas between names'
      input :location
      input :room
    end

    actions
  end
end
