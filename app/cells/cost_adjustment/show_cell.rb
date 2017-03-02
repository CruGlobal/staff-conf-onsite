class CostAdjustment::ShowCell < ::ShowCell
  property :child

  def show
    attributes_table do
      row :id
      row_person
      row_type
      row_price
      row_percent
      row_description
      row :created_at
      row :updated_at
    end

    active_admin_comments
  end

  private

  def row_person
    row('Person') { |ca| link_to(ca.person.full_name, ca.person) }
  end

  def row_type
    row('Type') { |ca| cost_type_name(ca) }
  end

  def row_price
    row(:price) { |ca| humanized_money_with_symbol(ca.price) if ca.price.present? }
  end

  def row_percent
    row(:percent) { |ca| "#{ca.percent}%" if ca.percent.present? }
  end

  def row_description
    row(:description) { |ca| html_full(ca.description) }
  end
end
