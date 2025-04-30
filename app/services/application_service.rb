class ApplicationService
  include ActiveModel::Model
  include ActiveModel::Callbacks
  extend Forwardable

  I18N_SCOPE = [:services].freeze

  define_model_callbacks :initialize

  class << self
    # Create a new service, initialized with the given arguments, and {#call} it
    # before returning the new service object.
    def call(*args)
      new(*args).tap(&:call)
    end

    def i18n_scope(scope = nil)
      @scope = scope if scope.present?
      @scope
    end
  end

  def initialize(*_args)
    run_callbacks(:initialize) { super }
  end

  def call
    # Empty implementation which may be overridden by implementors
  end

  protected

  def t(*args)
    opts = args.extract_options!
    opts[:scope] = I18N_SCOPE + Array(self.class.i18n_scope) + Array(opts[:scope])
    
    # For Rails 7.1+ compatibility
    if args.empty?
      raise ArgumentError, "Missing translation key"
    elsif args.size == 1
      I18n.t(args.first, **opts)
    else
      I18n.t(args.first, args.second, **opts)
    end
  end

  def l(*args)
    I18n.l(*args)
  end
end
