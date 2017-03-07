class HousingFacility::FormCell < ::FormCell
  def show
    show_errors_if_any

    inputs 'Details' do
      input :name
      input :housing_type
      input :cost_code, as: :select, collection: cost_code_select
      input :cafeteria
    end

    inputs 'Address' do
      input :street
      input :city
      input :state
      input :zip
      input :country_code, as: :select, collection: country_select
    end

    actions
  end
end
