module FoodHeadCount
  class CafeteriaDate
    include ActiveModel::Model
    include ActiveRecord::AttributeAssignment
    include ActiveModel::Serializers::Xml

    attr_accessor :date, :cafeteria, :id
    delegate :zero?, to: :total

    AGE_GROUPS = %i(adult child).freeze
    MEAL_TYPES = %i(breakfast lunch dinner).freeze
    MEAL_COUNTS =
      AGE_GROUPS.flat_map do |age|
        MEAL_TYPES.map do |meal|
          [age, meal].join('_').to_sym.tap { |attr| attr_accessor attr }
        end
      end

    def initialize(*_args)
      super
      zero_meal_counts
    end

    def increment(age, meal)
      attr = [age, meal].join('_').to_sym
      send("#{attr}=", (send(attr) || 0) + 1)
    end

    def total
      MEAL_COUNTS.inject(0) { |sum, name| sum + send(name) }
    end

    def attributes
      Hash[
        (%i(id date cafeteria) + MEAL_COUNTS).map { |name| [name, send(name)] }
      ]
    end

    private

    def zero_meal_counts
      MEAL_COUNTS.each { |attr| send("#{attr}=", 0) }
    end
  end
end
