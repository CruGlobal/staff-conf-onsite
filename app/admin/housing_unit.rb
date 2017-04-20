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

  permit_params :name
end
