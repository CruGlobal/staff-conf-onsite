class ShowCell < ApplicationCell
  property :actions,
           :active_admin_comments,
           :attributes_table,
           :attributes_table_for,
           :column,
           :columns,
           :insert_tag,
           :panel,
           :row,
           :selectable_column,
           :status_tag,
           :table_for,
           :text_node

  (Arbre::HTML::AUTO_BUILD_ELEMENTS + [:para]).each { |elem| property elem }
end
