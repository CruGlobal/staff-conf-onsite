module ApplicationHelper
  # Creates an HTML representation of the given attribute, depending on what
  # type of attribute it is: +text+ as paragraphs, +boolean+ as a checkbox, etc.
  #
  # @param record [ApplicationRecord] the record containing the attribute
  # @param attribute [Symbol] the name of the attribute to format
  # @return [Arbre::Context] a formatted representation of the given attribute
  def simple_format_attr(record, attribute)
    value = record.send(attribute)

    Arbre::Context.new do
      case record.class.columns_hash[attribute.to_s].type
      when :text then div(simple_format(value))
      when :boolean then status_tag(value ? :yes : :no)
      when :date then text_node(I18n.l(value, format: :month))
      else text_node(value)
      end
    end
  end
end
