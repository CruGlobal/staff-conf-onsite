ActiveAdmin.register HousingUnit do
  page_cells do |page|
    page.index title: -> { "#{@housing_facility.name}: Units" }
    page.show title: ->(hu) { "#{hu.housing_facility.name}: Unit #{hu.name}" }
    page.form
    page.sidebar 'Housing Facility'
  end

  config.sort_order = 'name_asc'
  order_by(:name) do |clause|
    if clause.order == 'desc'
      [
        'substring(name, \'^\D+\') NULLS LAST',
        'substring(name, \'\d+\')::int NULLS LAST',
        'name'
      ].join(', ') + ' desc'
    else
      [
        'substring(name, \'^\D+\') NULLS FIRST',
        'substring(name, \'\d+\')::int NULLS FIRST',
        'name'
      ].join(', ') + ' asc'
    end
  end

  belongs_to :housing_facility

  permit_params :name
end
