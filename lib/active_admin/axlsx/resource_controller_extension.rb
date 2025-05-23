module ActiveAdmin
  module Axlsx
    module ResourceControllerExtension
      def self.prepended(base)
        base.class_eval do
          alias_method :index_without_xlsx, :index
          alias_method :index, :index_with_xlsx
    
          respond_to :xlsx, only: :index
        end
      end

      # patching the index method to allow the xlsx format.
      def index_with_xlsx(&block)
        index_without_xlsx do |format|
           format.xlsx do
            xlsx = active_admin_config.xlsx_builder.serialize(collection)
            send_data xlsx, filename: "#{xlsx_filename}", type: Mime::Type.lookup_by_extension(:xlsx)
          end
        end
      end

      # Returns a filename for the xlsx file using the collection_name
      # and current date such as 'my-articles-2011-06-24.xlsx'.
      def xlsx_filename
        "#{resource_collection_name.to_s.gsub('_', '-')}-#{Time.now.strftime("%Y-%m-%d")}.xlsx"
      end
    end
  end
end
