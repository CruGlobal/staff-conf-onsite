class Ministry::ListMissing < ApplicationService
  include ActionView::Helpers::OutputSafetyHelper

  attr_accessor :sheets, :skip_first
  attr_reader :codes

  def call
    @codes = spreadsheet_ministry_codes - ministry_codes
  end

  def html_message
    safe_join [
      'The import file contains Ministries which do not exist in the database:',
      html_list
    ]
  end

  def html_list
    Arbre::Context.new(codes: codes) do
      ul do
        codes.each do |code|
          li { code }
        end
      end
    end
  end

  private

  def spreadsheet_ministry_codes
    sheets.flat_map(&method(:pluck_ministry_codes)).compact.uniq[1..-1].sort
  end

  def pluck_ministry_codes(sheet)
    sheet.each(Import::Person::SPREADSHEET_TITLES).map do |row|
      row[:ministry_code]
    end
  end

  def ministry_codes
    @ministry_names ||= Ministry.distinct.pluck(:code)
  end
end
