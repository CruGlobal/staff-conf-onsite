module ActiveAdmin::ViewHelpers
  # Overrides +ActiveAdmin::Views::TableFor::IndexTableFor+ such that the
  # "select all" checkbox is only available to users with the +bulk_edit?+
  # policy
  def selectable_column
    return unless model.active_admin_config.batch_actions.any? && policy.bulk_edit?

    column model.resource_selection_toggle_cell, class: 'col-selectable', sortable: false do |resource|
      model.resource_selection_cell resource
    end
  end
end
