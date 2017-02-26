module ActiveAdmin
  class ResourceDSL
    def page_cells(model_type = nil)
      model_type = controller.controller_name.singularize if model_type.nil?

      CellHelper.new(self, model_type).tap do |cell|
        yield(cell) if block_given?
      end
    end
  end

  class CellHelper
    def initialize(dsl, model_type)
      @dsl, @model_type = dsl, model_type
    end

    def method_missing(name, *args)
      prefix = "#{@model_type}/"

      @dsl.send name, *args do |resource|
        cell("#{prefix}#{name}", (name == :form ? resource : self)).call
        nil
      end
    end
  end
end
