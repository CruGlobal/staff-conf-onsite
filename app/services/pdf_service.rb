require 'prawn/measurement_extensions'

class PdfService < ApplicationService
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
    draw_text
    font
    font_families
    font_size
    move_down
    repeat
    stamp
    table
    text
    text_box
  ).freeze

  def_delegators :document, *PRAWN_METHODS
  def_delegator :document, :render, :render_pdf

  attr_accessor :author

  after_initialize :update_font_families

  def document
    @document ||= Prawn::Document.new(info: metadata)
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
