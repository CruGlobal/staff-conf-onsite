ActiveAdmin.register ChargeableStaffNumber do
  permit_params :staff_number

  index do
    selectable_column
    column :staff_number
    column :created_at
    actions
  end

  filter :staff_number
  filter :created_at

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :staff_number
          row :created_at
        end
      end

      column do
        panel 'Family' do
          if (family = chargeable_staff_number.family)
            strong { link_to(family.to_s, family_path(family)) }
          else
            strong 'None'
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.semantic_errors
    f.inputs do
      f.input :staff_number
    end
    f.actions
  end

  action_item :import_staff_numbers, only: :index do
    link_to 'Import Spreadsheet', action: :new_spreadsheet
  end

  collection_action :new_spreadsheet, title: 'Import Spreadsheet'
  collection_action :import_spreadsheet, method: :post do
    res =
      ImportChargeableStaffNumbersSpreadsheet.call(
        ActionController::Parameters.new(params).
          require('import_spreadsheet').
          permit(:file, :delete_existing, :skip_first)
      )

    if res.success?
      redirect_to chargeable_staff_numbers_path,
                  notice: 'Staff Numbers imported successfully.'
    else
      redirect_to new_spreadsheet_chargeable_staff_numbers_path,
                  flash: { error: res.message }
    end
  end
end
