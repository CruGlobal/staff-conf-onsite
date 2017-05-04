class HousingFacility::FormCell < ::FormCell
  def show
    show_errors_if_any

    detail_inputs
    address_inputs
    csu_inputs

    actions
  end

  private

  def detail_inputs
    inputs 'Details' do
      input :name
      input :housing_type
      input :cost_code, as: :select, collection: cost_code_select
      input :cafeteria
      input :on_campus
    end
  end

  def address_inputs
    inputs 'Address' do
      input :street
      input :city
      input :state
      input :zip
      input :country_code, as: :select, collection: country_select
    end
  end

  def csu_inputs
    inputs 'CSU' do
      input :csu_dorm_code
      input :csu_dorm_block
    end
  end
end
