module ViewsHelper
  # This creates instance methods for all of the module methods from the other
  # helper modules.
  #
  # ViewHelper is the only helper which is automatically mixed into ActiveAdmin
  # records. This extends all the other helpers so that their helper methods
  # are available to ActiveAdmin records. It also creates instance methods that
  # alias the module methods from te other helper modules so that they're also
  # available.
  #
  # The reason some helper methods are module methods is because ViewHelper's
  # instance methods are not available in the class context, so the module
  # methods must be used in those cases.
  begin
    modules =
      Dir[Rails.root.join('app', 'helpers', '*.rb')].map do |path|
        File.basename(path, '.rb').camelize.safe_constantize
      end

    modules.each do |mod|
      next if mod.nil? || mod == self

      extend mod

      (mod.public_methods - Module.public_methods).each do |method_name|
        define_method(method_name) { |*args| mod.send(method_name, *args) }
      end
    end
  end
end
