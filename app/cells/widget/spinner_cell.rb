# == Options
#
# [+classes+ [+Array<String>+]]
#   Additional classes to add to the SVG element
# [+size+ [+Numeric+]]
#   The height and width of the widget, in pixels
# [+duration+ [+Numeric+]]
#   The length of the animation loop, in seconds
# [+primary_color+ [+String+]]
#   The primary color of the animation. ex: '#ff0000'
# [+secondary_color+ [+String+]]
#   The secondary color of the animation. ex: '#0000ff'
class Widget::SpinnerCell < ArbreCell
  Rect = Class.new(Arbre::HTML::Tag)
  Animate = Class.new(Arbre::HTML::Tag)

  CLASSES = %w(spinner-widget).freeze
  SIZE = 48 # pixels
  DURATION = 5.0 # seconds
  COLORS = { primary: '#047ab3', secondary: '#00cde8' }.freeze
  SQUARE_LOCATIONS = [
    { x: 0, y: 0 },
    { x: 25, y: 0 },
    { x: 50, y: 0 },
    { x: 50, y: 25 },
    { x: 50, y: 50 },
    { x: 25, y: 50 },
    { x: 0, y: 50 },
    { x: 0, y: 25 }
  ].freeze

  def show
    svg(width: size, height: size, viewBox: '0 0 70 70', preserveAspectRatio:
        'xMidYMid', xmlns: 'http://www.w3.org/2000/svg', class: classes) do
      SQUARE_LOCATIONS.each_with_index do |location, i|
        square(location) { animate_fill(begin: sec(duration.to_f / 8 * i)) }
      end
    end
  end

  private

  def classes
    (Array(@options[:classes]) + CLASSES).uniq.join(' ')
  end

  def size
    @options.fetch(:size, SIZE)
  end

  def duration
    @options.fetch(:duration, DURATION)
  end

  def primary_color
    @options.fetch(:primary_color, COLORS[:primary])
  end

  def secondary_color
    @options.fetch(:secondary_color, COLORS[:secondary])
  end

  def sec(time)
    "#{time}s"
  end

  def square(*args, &blk)
    if (opts = args.last).is_a?(Hash)
      opts.merge!(width: 20, height: 20, fill: COLORS[:primary])
    end
    rect(*args, &blk)
  end

  def rect(*args, &blk)
    insert_tag Rect, *args, &blk
  end

  def animate_fill(*args, &blk)
    if (opts = args.last).is_a?(Hash)
      opts.merge!(attributeName: :fill, repeatCount: :indefinite, dur: DURATION,
                  from: COLORS[:primary], to: COLORS[:secondary],
                  values: gradient, keyTimes: '0;0.1;0.2;1')
    end
    animate(*args, &blk)
  end

  def animate(*args, &blk)
    insert_tag Animate, *args, &blk
  end

  def gradient
    [secondary_color, secondary_color, primary_color, primary_color].join(';')
  end
end
