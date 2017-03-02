class CostCode::ShowCell < ::ShowCell
  property :cost_code

  def show
    columns do
      column { cost_code_attributes_table }
      column { charges_panel }
    end

    active_admin_comments
  end

  private

  def cost_code_attributes_table
    attributes_table do
      row(:name) { |c| strong c.name }
      row(:description) { |c| html_summary(c.description) }
      row :min_days
      row :created_at
      row :updated_at
    end
  end

  def charges_panel
    panel 'Charges' do
      attributes_table_for cost_code.charges.order(:max_days) do
        row_max_days
        row_adult
        row_teen
        row_child
        row_infant
        row_child_meal
        row_single_delta
      end
    end
  end

  def row_max_days
    row(:max_days) { |c| strong c.max_days }
  end

  def row_adult
    row(:adult) { |c| humanized_money_with_symbol(c.adult) }
  end

  def row_teen
    row(:teen) { |c| humanized_money_with_symbol(c.teen) }
  end

  def row_child
    row(:child) { |c| humanized_money_with_symbol(c.child) }
  end

  def row_infant
    row(:infant) { |c| humanized_money_with_symbol(c.infant) }
  end

  def row_child_meal
    row(:child_meal) { |c| humanized_money_with_symbol(c.child_meal) }
  end

  def row_single_delta
    row(:single_delta) { |c| humanized_money_with_symbol(c.single_delta) }
  end
end
