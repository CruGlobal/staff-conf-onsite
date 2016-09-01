require 'phone'
require 'truncate_html'

module TextHelper
  class << self
    include ActionView::Helpers::TagHelper
  end

  module_function

  def html_summary(html)
    html_string = TruncateHtml::HtmlString.new(html)
    # rubocop:disable Rails/OutputSafety
    TruncateHtml::HtmlTruncator.new(html_string).truncate.html_safe
  end

  def format_phone(number)
    if (phone = Phoner::Phone.parse(number))
      phone.format('+%c (%a) %f-%l')
    else
      ''
    end
  rescue
    number
  end
end
