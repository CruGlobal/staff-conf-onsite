class Seminary::IndexCell < ::IndexCell
  def show
    selectable_column

    column :name
    column :code
    column_course_price
    column :created_at
    column :updated_at

    actions
  end

  private

  def column_course_price
    column(:course_price) { |c| humanized_money_with_symbol(c.course_price) }
  end
end
