module ChildcareHelper
  module_function

  # @return [Array<[label, id]>] the {Childcare::CHILDCARE_WEEKS childcare
  #   weeks} +<select>+ options acceptable for +options_for_select+
  def childcare_weeks_select
    Childcare::CHILDCARE_WEEKS.each_with_index.map.to_a
  end

  # @return [Array<[label, id]>] the {Childcare} +<select>+ options acceptable
  #   for +options_for_select+
  def childcare_spaces_select
    Childcare.all.order(:title).map do |c|
      [
        [c.title, c.teachers, c.address, "size:#{c.children.size}"].join(' | '),
        c.id
      ]
    end
  end

  # @param child [Child] Some kid.
  # @return [Arbre::Context] an HTML +<ul>+ list of the {Childcare} weeks been
  #   attended by the given +Child+, or a message if the child is not attending
  #   any +Childcare+
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

  # @return [String] a string describing the Childcare week represented by the
  #   given integer
  def childcare_weeks_label(index)
    Childcare::CHILDCARE_WEEKS[index]
  end
end
