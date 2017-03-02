class ChargeableStaffNumber::ShowCell < ::ShowCell
  property :chargeable_staff_number

  def show
    columns do
      column { chargeable_staff_number_attributes_table }
      column { family_panel }
    end

    active_admin_comments
  end

  private

  def chargeable_staff_number_attributes_table
    attributes_table do
      row :id
      row :staff_number
      row :created_at
    end
  end

  def family_panel
    panel 'Family', class: 'family' do
      if (family = chargeable_staff_number.family)
        strong { link_to(family.to_s, family_path(family)) }
      else
        strong 'None'
      end
    end
  end
end
