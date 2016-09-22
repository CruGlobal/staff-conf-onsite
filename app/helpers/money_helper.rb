module MoneyHelper
  module_function

  def format_cents(cents)
    Money.new(cents, 'USD').format
  end
end
