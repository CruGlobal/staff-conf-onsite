# Delegates the creation of this resource to a collection of {Cell Cells}.  The
# +Cell+ subclasses chosen for delegation are based on the name of the resource
# and a DSL-based definition.
module PageCells
  # This method yields a DSL object which the caller defines actions (with
  # option arguments). The action names given via the DSL object define the
  # +Cell+ subclasses used.
  #
  # In the following example, the +MyClass+ resource would delegate the
  # +MyClass#index+ call to +MyClass::IndexCell+ and +MyClass#show+ to
  # +MyClass::ShowIndex+.
  #
  # @example Example DSL Usage
  #   ActiveAdmin.register MyClass do
  #     page_cells do |page|
  #       page.index
  #       page.show title: ->(c) { "Hello, #{c.name}" }
  #     end
  #   end
  #
  # @param namespace [#to_s, nil] the namespace of the resolved {Cell Cells}. If
  #   +nil+, the name of the resource will be used
  # @yieldparam page [CellResourceDSL]
  # @return [CellResourceDSL]
  def page_cells(namespace = nil)
    namespace ||= controller.controller_name.singularize

    CellResourceDSL.new(self, namespace).tap do |cell|
      yield(cell) if block_given?
    end
  end
end

# Passed to the resource DSL to define which cells are used to delegate the
# resource's definition.
class CellResourceDSL
  attr_reader :dsl, :namespace

  # @param dsl [ResourceDSL]
  # @param namespace [#to_s] the namespace of the resolved {Cell Cells}
  def initialize(dsl, namespace)
    @dsl = dsl
    @namespace = namespace
  end

  # This method necessarily breaks a few Reek rules to implement the
  # +Object#respond_to_missing?+ interface:
  # * +:reek:BooleanParameter+
  # * +:reek:ManualDispatch+
  def respond_to_missing?(method_name, _include_private = false)
    dsl.respond_to?(method_name, true)
  end

  # :reek:ManualDispatch
  # @param name [Symbol] defines a method of {#dsl} to be delegated to a {Cell}
  # @param args [Array] arguments to be delegated to the {#dsl} method call
  def method_missing(name, *args)
    respond_to?(name) ? delegate_cell("#{namespace}/", name, args) : super
  end

  private

  def delegate_cell(prefix, name, args)
    dsl.send name, *args do |resource|
      cell("#{prefix}#{name}", (name == :form ? resource : self)).call
      nil # avoids a double-render
    end
  end
end
