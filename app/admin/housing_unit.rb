ActiveAdmin.register HousingUnit do
  page_cells do |page|
    page.index title: -> { "#{@housing_facility.name}: Units" }
    page.show title: ->(hu) { "#{hu.housing_facility.name}: Unit #{hu.name}" }
    page.form
    page.sidebar 'Housing Facility'
  end

  config.sort_order = 'name_asc'
  order_by(:name) { |clause| HousingUnit.natural_order(clause.order) }

  belongs_to :housing_facility

  permit_params :name, :occupancy_type

  controller do
    rescue_from ActiveRecord::DeleteRestrictionError,
                with: :redirect_delete_restriction

    private

    def redirect_delete_restriction(_exception)
      redirect_to housing_facility_housing_unit_path(params[:housing_facility_id], params[:id]),
                  alert: 'Could not delete this Unit because people are' \
                         ' currently assigned to it.'
    end
  end
end
