module CollectionAttributes
  extend ActiveSupport::Concern

  class_methods do
    def single_selection_collections
      @single_selection_collections ||= {}
    end

    def multi_selection_collections
      @multi_selection_collections ||= {}
    end

    def single_selection_attributes(collection_attributes_and_values)
      collection_attributes_and_values.each do |attribute_name, values|
        validates attribute_name, inclusion: { in: values, allow_nil: true }
        single_selection_collections[attribute_name] = values
      end
    end

    def multi_selection_attributes(collection_attributes_and_values)
      collection_attributes_and_values.each do |attribute_name, values|
        define_collection_attribute_writer(attribute_name)
        validates attribute_name, array: { collection: values }
        multi_selection_collections[attribute_name] = values
      end
    end

    def define_collection_attribute_writer(collection_attribute_name)
      define_method "#{collection_attribute_name}=" do |new_value|
        new_value = new_value.split(',').map(&:strip) if new_value.is_a?(String)
        new_value.reject!(&:blank?) if new_value.is_a?(Array)
        super(new_value)
      end
    end
  end
end
