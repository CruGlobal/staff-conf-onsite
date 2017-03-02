ActiveAdmin.register ChargeableStaffNumber do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  permit_params :staff_number

  index do
    selectable_column
    column :staff_number
    column :created_at
    actions
  end

  filter :staff_number
  filter :created_at

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
