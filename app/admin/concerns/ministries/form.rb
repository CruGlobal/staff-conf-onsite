module Ministries
  module Form
    def self.included(base)
      create_spreadsheet_upload_actions(base)

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

    def self.create_spreadsheet_upload_actions(base)
      base.send :action_item, :import_spreadsheet, only: :index do
        link_to 'Import Spreadsheet', action: :new_spreadsheet
      end

      base.send :collection_action, :new_spreadsheet, title: 'Import Spreadsheet'
      create_import_action(base, :ministries, ImportMinistriesSpreadsheet)
      create_import_action(base, :hierarchy, ImportMinistryHierarchySpreadsheet)
    end

    # Creates a POST action to process an uploaded spreadsheet file.
    # @param [Class] base The ActiveAdmin resource class to add the actions to
    # @param [Symbol,String] action The name of the action
    # @param [Interactor] interactor - The service object which will process
    #   the upload
    def self.create_import_action(base, action, interactor)
      base.send :collection_action, "import_#{action}", method: :post do
        res =
          interactor.call(
            ActionController::Parameters.new(params).
              require("spreadsheet_import_#{action}").
              permit(:file, :skip_first)
          )

        if res.success?
          redirect_to ministries_path, notice: "#{action.to_s.titleize} imported successfully."
        else
          redirect_to new_spreadsheet_ministries_path, flash: { error: res.message }
        end
      end
    end
  end
end