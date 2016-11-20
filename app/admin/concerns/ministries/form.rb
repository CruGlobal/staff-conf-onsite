module Ministries
  module Form
    def self.included(base)
      setup_uploads(base)

      base.send :form do |f|
        f.semantic_errors
        f.inputs do
          f.input :code
          f.input :name
          select_ministry_widget(f, :parent)
        end
        f.actions
      end
    end

    def self.setup_uploads(base)
      base.send :action_item, only: :index do
        link_to 'Import Spreadsheet', action: :new_spreadsheet
      end

      base.send :collection_action, :new_spreadsheet, title: 'Import Spreadsheet'
      create_import(base, :ministries, ImportMinistriesSpreadsheet)
      create_import(base, :hierarchy, ImportMinistryHierarchySpreadsheet)
    end

    def self.create_import(base, action, interactor)
      base.send :collection_action, "import_#{action}", method: :post do
        res = interactor.call(file: params[:spreadsheet]['file'])

        if res.success?
          message = "#{action.to_s.titleize} imported successfully."
          redirect_to ministries_path, notice: message
        else
          redirect_to new_spreadsheet_ministries_path, notice: res.message
        end
      end
    end
  end
end
