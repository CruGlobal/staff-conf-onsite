module ChildcareHelper
  module_function

  def childcare_weeks_select
    Childcare::CHILDCARE_WEEKS.each_with_index.map.to_a
  end

  def childcare_spaces_select
    Childcare.all.order(:title).map do |c|
      [
        [c.title, c.teachers, c.address, "size:#{c.children.size}"].join(' | '),
        c.id
      ]
    end
  end

  def childcare_weeks_list(child)
    labels = child.childcare_weeks.map { |w| childcare_weeks_label(w) }

    Arbre::Context.new do
      if labels.any?
        ul do
          labels.each { |week_label| li { week_label } }
        end
      else
        span I18n.t('activerecord.attributes.child.childcare_week_numbers.none')
      end
    end
  end

  def childcare_weeks_label(index)
    Childcare::CHILDCARE_WEEKS[index]
  end
end
