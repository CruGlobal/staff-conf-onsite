class Childcare::Checklist < PdfService
  COLUMNS = ['Last Name, First Name', 'Sign-In', 'Sign-Out'].freeze

  attr_accessor :childcare
  attr_accessor :week

  def call
    font 'Comic Sans'

    children_table

    repeat(:all) { printed_at_footer }
  end

  def metadata
    super.tap do |meta|
      meta[:Title] = format('Checklist: %s', childcare.name)
    end
  end

  private

  def children_table
    data = [COLUMNS] + table_rows

    move_down 0.5.in

    table data, header: true, position: :center, width: bounds.width do |t|
      t.cells.borders = []

      t.row(0).font_style = :bold
      t.row(0).borders = [:bottom]
      t.row(0).border_width = 2

      style_row_span_cells(t)
      style_input_cells(t)
    end
  end

  def style_row_span_cells(t)
    name_size = font_size * 1.25
    name_column = t.row(1..-1).columns(0)

    name_column.valign = :center
    name_column.borders = [:bottom]
    name_column.border_width = 2
    name_column.padding = 0.2.in
    name_column.size = name_size
  end

  def style_input_cells(t)
    input_columns = t.row(1..-1).columns(-2..-1)
    input_columns.borders = [:left, :bottom]
    input_columns.border_bottom_width = 2
  end

  def table_rows
    children.map { |child| [name_cell(child), '', ''] }
  end

  def name_cell(child)
    "#{child.last_name}\n#{nbsp + nbsp + nbsp}#{child.first_name}"
  end

  def children
    @children ||= begin
      children =
        childcare.children.order(:last_name, :first_name).select do |child|
          child.childcare_weeks.include?(week)
        end

      children.any? ? children : [Child.new]
    end
  end
end
