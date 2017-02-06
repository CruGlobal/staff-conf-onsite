ActiveAdmin.register HousingUnit do
  belongs_to :housing_facility

  permit_params :name

  index title: -> { "#{@housing_facility.name}: Units" } do
    column :id
    column(:name) { |r| h4 r.name }
    column :created_at
    column :updated_at
    actions
  end

  show title: ->(r) { "#{r.housing_facility.name}: Units #{r.name}" } do
    columns do
      column do
        attributes_table do
          row :id
          row :name
          row :housing_facility
          row(:housing_type) { |u| housing_type_label(u.housing_facility) }
          row :created_at
          row :updated_at
        end
      end

      column do
        stays = housing_unit.stays.order(:arrived_at)
        panel "Assignments (#{stays.size})" do
          if stays.any?
            ol do
              housing_unit.stays.order(:arrived_at).each do |stay|
                li do
                  dates =
                    [:arrived_at, :departed_at].map do |attr|
                      simple_format_attr(stay, attr)
                    end

                  text_node link_to stay.person.full_name, stay.person
                  text_node ": #{dates.join(' until ')}"
                end
              end
            end
          else
            strong 'None'
          end
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs do
      f.input :name
    end

    f.actions
  end

  sidebar 'Housing Facility' do
    h4 strong link_to(housing_facility.name, housing_facility_path(housing_facility))
  end

  action_item :import_rooms, only: :index do
    link_to 'Import Spreadsheet',
            new_spreadsheet_housing_facility_path(params[:housing_facility_id])
  end
end
