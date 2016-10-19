module ChildcareHelper
  module_function

  def childcare_weeks_select
    Childcare::CHILDCARE_WEEKS
  end

  def childcare_spaces_select
    Childcare.all.order(:title).map do |c|
      [
        [c.title, c.teachers, c.address, "size:#{c.children.size}"].join(' | '),
        c.id
      ]
    end
  end
end
