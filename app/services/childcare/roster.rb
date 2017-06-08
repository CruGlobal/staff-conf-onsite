class Childcare::Roster < PdfService
  attr_accessor :childcare
  attr_accessor :date

  TITLE_SIZE_FACTOR = 2.5
  HEADER_SIZE_FACTOR = 1.5

  # @see http://fontawesome.io/icon/square-o
  HOT_LUNCH_NO  = "\uf096".freeze

  # @see http://fontawesome.io/icon/check-square-o
  HOT_LUNCH_YES = "\uf046".freeze

  def render
    font 'Comic Sans'

    header
    children_table

    repeat(:all) { footer }

    render_pdf
  end

  def metadata
    super.tap do |meta|
      meta[:Title] = format('Roster: %s', childcare.name)
    end
  end

  private

  def header
    text childcare.name, align: :center, style: :bold,
                         size: font_size * TITLE_SIZE_FACTOR
    header_table
  end

  def header_table
    data = [
      ['Location:', childcare.location],
      ['Room #:', childcare.room],
      ['Counselors:', childcare.teachers]
    ]

    font_size(font_size * HEADER_SIZE_FACTOR) do
      table data, position: :center, cell_style: { border_width: 0 } do
        column(0).align = :right
        column(0).width = 2.in
        column(1).font_style = :bold
      end
    end
  end

  def children_table
    move_down 0.5.in

    table children_data, header: true, position: :center, width: bounds.width do
      cells.borders = []

      row(0).font_style = :bold
      row(0).borders = [:bottom]
      row(0).border_width = 2

      column(2..3).align = :center
      column(3).rows(1..-1).font = 'FontAwesome'
    end
  end

  def children_data
    [table_header] + table_rows
  end

  def table_header
    ['Last Name', 'First Name', 'Gender', 'Hot Lunch?']
  end

  def table_rows
    children.map do |child|
      [
        child.last_name,
        child.first_name,
        child.gender&.upcase,
        hot_lunch?(child) ? HOT_LUNCH_YES : HOT_LUNCH_NO
      ]
    end
  end

  def children
    childcare.children.order(:last_name, :first_name)
  end

  def hot_lunch?(child)
    child.hot_lunch_dates.include?(date)
  end

  def footer(padding: 5.mm)
    canvas do
      text_box format('Printed: %s ', creation_date),
               align: :right,
               at: [0, bounds.bottom + font_size + padding],
               width: bounds.width - padding
    end
  end
end
