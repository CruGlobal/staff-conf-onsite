module CountryHelper
  FIRST_CODE = 'US'.freeze

  module_function

  def country_select
    @country_select =
      begin
        countries = ISO3166::Country.translations.dup
        first_name = countries.delete(FIRST_CODE)

        countries.
          map { |code, name| [name, code] }.
          tap { |c| c.unshift([first_name, FIRST_CODE], ['---', nil]) }
      end
  end

  def country_name(code)
    ISO3166::Country.translations[code]
  end
end
