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

  (Arbre::HTML::AUTO_BUILD_ELEMENTS + [:para] - [:object]).each do |elem|
    property elem
  end

  # The +Arbre+ method {#object} conflicts with a pre-existing +Cell+ method
  def object_element
    model.object
  end

  make_method_return_nil :active_admin_comments
end
