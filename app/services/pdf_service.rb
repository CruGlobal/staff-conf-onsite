require 'prawn/measurement_extensions'

class PdfService < ApplicationService
  TITLE_SIZE_FACTOR = 2.5
  HEADER_SIZE_FACTOR = 1.25

  # @see +app/assets/fonts/+
  # @see https://github.com/prawnpdf/prawn/tree/master/lib/prawn/font/
  EXTRA_FONTS = {
    'Comic Sans' => {
      normal: 'ComicSans.ttf',
      bold:   'ComicSans-Bold.ttf'
    }.freeze,
    'DejaVu Sans' => {
      normal:      'DejaVuSans.ttf',
      bold:        'DejaVuSans-Bold.ttf',
      italic:      'DejaVuSans-Oblique.ttf',
      bold_italic: 'DejaVuSans-BoldOblique.ttf'
    }.freeze,
    'FontAwesome' => {
      normal: 'FontAwesome.ttf',
      bold: 'FontAwesome.ttf'
    }.freeze
  }.freeze

  PRAWN_METHODS = %i(
    bounding_box
    bounds
    canvas
    create_stamp
    cursor
    draw_text
    font
    font_families
    font_size
    move_down
    repeat
    stamp
    start_new_page
    table
    text
    text_box
  ).freeze

  def_delegators :document, *PRAWN_METHODS
  def_delegator :document, :render, :render_pdf

  attr_accessor :author
  attr_writer :document

  after_initialize :update_font_families

  class << self
    def page_layout(layout = nil)
      @page_layout = layout if layout.present?
      @page_layout || :portrait
    end
  end

  def render
    render_pdf
  end

  def document
    @document ||= Prawn::Document.new(info: metadata,
                                      page_layout: self.class.page_layout)
  end

  def metadata
    {
      Author: author&.full_name || author,
      CreationDate: creation_date,
      Producer: ActiveAdmin.application.site_title
    }
  end

  def creation_date
    @creation_date ||= Time.zone.now
  end

  protected

  def shy
    Prawn::Text::SHY
  end

  def nbsp
    Prawn::Text::NBSP
  end

  def zwsp
    Prawn::Text::ZWSP
  end

  # A bounding-box may be required if there is repeating content above the
  # table, so it doesn't overlap the table if the table spans more than one
  # page.
  #
  # @see #repeat
  def wrap_table(&blk)
    bounding_box([bounds.left, cursor], width: bounds.width, &blk)
  end

  def title_font_size
    font_size * TITLE_SIZE_FACTOR
  end

  def header_font_size
    font_size * HEADER_SIZE_FACTOR
  end

  def printed_at_footer(padding: 5.mm)
    canvas do
      text_box format('Printed: %s ', creation_date),
               align: :right,
               at: [0, bounds.bottom + font_size + padding],
               width: bounds.width - padding
    end
  end

  private

  def update_font_families
    font_families.update(Hash[
      EXTRA_FONTS.map do |family, fonts|
        styles =
          Hash[fonts.map { |style, filename| [style, font_path(filename)] }]
        [family, styles]
      end
    ])
  end

  def font_path(*args)
    Rails.root.join('app', 'assets', 'fonts', *args)
  end
end
