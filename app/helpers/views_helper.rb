module ViewsHelper
  # This creates instance methods for all of the module methods from the other
  # helper modules.
  #
  # The reason every other helper consists of only module methods, and
  # ViewHelper consists of "instance aliases" of those module methods, is
  # because:
  #
  #   1. Only ViewHelper is mixed into ActiveAdmin resources.
  #   2. ViewHelper's instance methods are not available in the class_eval
  #      context, so the module methods must be used in those cases.
  Dir[Rails.root.join('app', 'helpers', '*.rb')].map do |path|
    File.basename(path, '.rb').camelize.safe_constantize
  end.compact.each do |mod|
    (mod.public_methods - Module.public_methods).each do |method_name|
      method = mod.method(method_name)
      define_method(method_name) { |*args| instance_exec(*args, &method) }
    end
  end
end
