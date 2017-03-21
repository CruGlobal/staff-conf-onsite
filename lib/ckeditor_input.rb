# Create's an ActiveAdmin input for the `ckeditor_rails` gem.
#
# Usage: f.input :html, as: :ckeditor
class CkeditorInput
  include Formtastic::Inputs::Base

  def to_html
    input_wrapping do
      label_html << builder.text_area(method, input_html_options)
    end
  end

  private

  def input_html_options
    super.tap do |opts|
      opts[:class] = Array(opts[:class].try(:split)).push('ckeditor_input').uniq.join(' ')
      # opts[:class] = 'ckeditor_input'
      # if opts.key?(:class)
      #   opts[:class] += ' ckeditor_input'
      # else
      #   opts[:class] = 'ckeditor_input'
      # end
    end
  end
end
