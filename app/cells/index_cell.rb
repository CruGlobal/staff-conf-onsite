class IndexCell < ShowCell
  property :id_column

  # Overrides +ActiveAdmin::Views::TableFor::IndexTableFor+ such that the
  # "select all" checkbox is only available to users with the +bulk_edit?+
  # policy
  def selectable_column
    return unless model.active_admin_config.batch_actions.any?

    column resource_selection_toggle_cell, class: 'col-selectable', sortable: false do |resource|
      model.resource_selection_cell resource
    end
  end

  def resource_selection_toggle_cell
    model.resource_selection_toggle_cell if policy.bulk_edit?
  end
end
