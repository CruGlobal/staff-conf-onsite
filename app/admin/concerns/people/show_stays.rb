module People
  module ShowStays
    STAYS_PANEL ||= proc do |person|
      panel 'Housing Assignments' do
        attributes_table_for person.stays.order(:arrived_at) do
          row(:housing_type) do |stay|
            strong housing_type_label(stay.housing_type)
          end
          row(:housing_facility) do |stay|
            facility = stay.housing_unit.try(:housing_facility)
            link_to facility.name, housing_facility_path(facility) if facility
          end
          row :housing_unit
          row :arrived_at
          row :departed_at
          row('Duration') do |stay|
            if stay.arrived_at.present? && stay.departed_at.present?
              pluralize (stay.departed_at.mjd - stay.arrived_at.mjd), 'Day'
            else
              strong 'N/A'
            end
          end

          Stay::HOUSING_TYPE_FIELDS.each do |attribute, types|
            row attribute do |stay|
              t = stay.housing_type

              if types.include?(t.to_sym)
                simple_format_attr(stay, attribute)
              else
                span('N/A', class: 'empty')
              end
            end
          end

          row(:comment) { |stay| html_full stay.comment }
        end
      end
    end
  end
end
