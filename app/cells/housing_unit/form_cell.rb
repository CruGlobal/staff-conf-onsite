class HousingUnit::FormCell < ::FormCell
  property :housing_unit

  def show
    show_errors_if_any

    inputs do
      input :name
    end

    actions
  end
end
