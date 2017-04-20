ActiveAdmin.register Ministry do
  page_cells do |page|
    page.index
    page.show
    page.form
  end

  permit_params :name, :code, :name, :parent_id

  filter :code
  filter :name
  filter :created_at
  filter :updated_at

  collection_action :new_spreadsheet, title: 'Import Spreadsheet'
  action_item :import_spreadsheet, only: :index do
    link_to 'Import Spreadsheet', action: :new_spreadsheet
  end

  collection_action :import_ministries, method: :post do
    res =
      Ministry::ImportSpreadsheet.call(
        ActionController::Parameters.new(params).
          require(:spreadsheet_import_ministries).
          permit(:file, :skip_first)
      )

    if res.success?
      redirect_to ministries_path, notice: 'Ministries imported successfully.'
    else
      redirect_to new_spreadsheet_ministries_path, flash: { error: res.message }
    end
  end

  collection_action :import_hierarchy, method: :post do
    res =
      Ministry::ImportHierarchySpreadsheet.call(
        ActionController::Parameters.new(params).
          require(:spreadsheet_import_hierarchy).
          permit(:file, :skip_first)
      )

    if res.success?
      redirect_to ministries_path, notice: 'Hierarchy imported successfully.'
    else
      redirect_to new_spreadsheet_ministries_path, flash: { error: res.message }
    end
  end
end
