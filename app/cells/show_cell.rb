class ShowCell < ApplicationCell
  include ActiveAdmin::ViewHelpers::DisplayHelper

  property :actions,
           :active_admin_application,
           :active_admin_comments,
           :attributes_table,
           :attributes_table_for,
           :column,
           :columns,
           :localize,
           :panel,
           :row,
           :selectable_column,
           :status_tag,
           :table_for
end
