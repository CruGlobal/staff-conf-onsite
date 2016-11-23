ActiveAdmin.register HousingFacility do
  permit_params :name, :street, :city, :state, :country_code, :zip

  index do
    selectable_column
    column :id
    column(:name) { |hf| h4 hf.name }
    column :street
    column :city
    column :state
    column(:country_code) { |hf| country_name(hf.country_code) }
    column :zip
    column 'Units' do |hf|
      link_to hf.housing_units.count, housing_facility_housing_units_path(hf)
    end
    column :created_at
    column :updated_at
    actions
  end

  form do |f|
    f.semantic_errors

    f.inputs :name

    f.inputs 'Address' do
      f.input :street
      f.input :city
      f.input :state
      f.input :zip
      f.input :country_code, as: :select, collection: country_select
    end
    f.actions
  end

  filter :name
  filter :street
  filter :city
  filter :state
  filter :country_code, as: :select, collection: CountryHelper.country_select
  filter :zip
  filter :created_at
  filter :updated_at

  sidebar 'Units', only: [:show, :edit] do
    h4 strong link_to('All Units',
                      housing_facility_housing_units_path(housing_facility))
    h4 strong 'Recently Changed'

    ul do
      housing_facility.housing_units.order(updated_at: :desc).map do |r|
        li link_to(r.name,
                   housing_facility_housing_unit_path(housing_facility, r.id))
      end
    end
  end
end
