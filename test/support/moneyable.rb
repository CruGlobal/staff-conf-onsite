module Support
  module Moneyable
    extend ActiveSupport::Concern

    included do
      def self.test_money_attr(factory, attr)
        test "#{attr}=" do
          model = instance_variable_get("@#{factory}".to_sym)
          model ||= create(factory)

          model.update(attr => 100)
          assert_equal 100, model.send(attr)

          model.update(attr => '100')
          assert_equal 100, model.send(attr)

          model.update(attr => '$USD 1.00')
          assert_equal 100, model.send(attr)

          model.update(attr => '$USD 0.00')
          assert_equal 0, model.send(attr)

          model.update(attr => '$USD 123.45')
          assert_equal 12345, model.send(attr)

          model.update(attr => '1,234,567.89')
          assert_equal 123456789, model.send(attr)
        end
      end
    end
  end
end
