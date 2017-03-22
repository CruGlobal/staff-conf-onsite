class Seminary::ShowCell < ::ShowCell
  property :seminary

  def show
    attributes_table do
      row :id
      row :name
      row :code
      row(:course_price) { |s| humanized_money_with_symbol(s.course_price) }
      row :created_at
      row :updated_at
    end
  end
end
