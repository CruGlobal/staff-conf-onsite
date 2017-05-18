class ApplicationService
  include ActiveModel::Model
  include ActiveModel::Callbacks

  define_model_callbacks :initialize

  class << self
    # Create a new service, initialized with the given arguments, and {#call} it
    # before returning the new service object.
    def call(*args)
      new(*args).tap(&:call)
    end
  end

  def initialize(*_args)
    run_callbacks(:initialize) { super }
  end
end
