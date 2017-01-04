module ApplicationHelper
  # Creates an HTML representation of the given attribute, depending on what
  # type of attribute it is: +text+ as paragraphs, +boolean+ as a checkbox, etc.
  #
  # @param record [ApplicationRecord] the record containing the attribute
  # @param attribute [Symbol] the name of the attribute to format
  # @return [Arbre::Context] a formatted representation of the given attribute
  def simple_format_attr(record, attribute)
    value = record.send(attribute)
    helper = self

    Arbre::Context.new do
      case record.class.columns_hash[attribute.to_s].type
      when :text then div(helper.simple_format(value))
      when :boolean then status_tag(value ? :yes : :no)
      when :date then text_node(I18n.l(value, format: :month))
      else text_node(value)
      end
    end
  end

  # Creates a datepicker UI element with useful default options.
  #
  # @param form [Formtastic Form] the form DSL object
  # @param attribute [Symbol] the name of the attribute to create a date input
  #   element for
  # @param opts [Hash] additional options for the input field
  def datepicker_input(form, attribute, opts = {})
    opts.reverse_merge!(
      as: :datepicker,
      datepicker_options: {
        changeYear: true,
        changeMonth: true,
        yearRange: 'c-60:c+10'
      }
    )

    form.input attribute, opts
  end
end
