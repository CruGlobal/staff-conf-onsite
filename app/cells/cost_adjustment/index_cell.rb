class CostAdjustment::IndexCell < ::IndexCell
  def show
    selectable_column

    column_person
    column_type
    column_price
    column_percent
    column_description
    column :created_at
    column :updated_at

    actions
  end

  private

  def column_person
    column('Person') { |ca| link_to(ca.person.full_name, ca.person) }
  end

  def column_type
    column('Type') { |ca| cost_type_name(ca) }
  end

  def column_price
    column(:price) { |ca| humanized_money_with_symbol(ca.price) if ca.price.present? }
  end

  def column_percent
    column(:percent) { |ca| "#{ca.percent}%" if ca.percent.present? }
  end

  def column_description
    column(:description) { |ca| html_summary(ca.description) }
  end
end
