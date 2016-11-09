module MinistryHelper
  module_function

  def ministry_code_label(code)
    "#{code}: #{I18n.t("activerecord.attributes.ministry.codes.#{code}")}"
  end

  def ministry_code_select
    Ministry::CODES.map { |code| [ministry_code_label(code), code] }
  end
end
