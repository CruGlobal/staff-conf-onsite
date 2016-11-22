class CreateOrUpdateMinistries
  include Interactor

  Error = Class.new(StandardError)

  def call
    Ministry.transaction do
      context.sheets.each { |sheet| process_sheet(sheet) }
      ministries.each(&:save!)
    end
  rescue Error => e
    context.fail! message: e.message
  end

  private

  def process_sheet(sheet)
    sheet.each_with_index do |row, i|
      row = row.map(&:strip).select(&:present?)

      if row.size < 2
        raise Error, "Row ##{i + 1} has too few columns. '#{row.join(',')}'"
      end

      create_or_update(row[0], row[1])
    end
  end

  def create_or_update(code, name)
    if (existing = find_by_code(code))
      existing.name = name
    else
      ministries.push(Ministry.new(code: code, name: name))
    end
  end

  def find_by_code(code)
    ministries.find { |m| m.code == code }
  end

  def ministries
    @ministries ||= Ministry.all.to_a
  end
end
